const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')(functions.config().stripe.testkey);
const cors = require('cors')({origin: true});
const gcs = require('@google-cloud/storage')()

admin.initializeApp(functions.config().firebase);

// Create a stripe customer id for each user created on database
// TODO: this includes both student and tutor, need to between  them
exports.createStripeUser = functions.auth.user().onCreate(event => {
	const data = event.data;
	console.log("creating a new user!");
	console.log(data);
	return stripe.customers.create().then(customer => {

		console.log("creating stripe customer");
		console.log(customer);
		// To use when integrated, use phone number as uid
		// return admin.database().ref(`/users/${data.phoneNumber}/payments/customerId`).set(customer.id);
		return admin.database().ref(`/users/${data.phoneNumber}/payments/customerId`).set(customer.id);
	});
});

// 
exports.stripeCharge = functions.database
								.ref('/users/{userId}/payments/charges/{id}')
								.onWrite(event => {
									console.log('wirte triggered');
									const val = event.data.val();
									console.log("what is val");
									console.log(val);

									if (val === null || val.id || val.error) return null;

									return admin.database()
												.ref(`/users/${event.params.userId}/payments/customerId`)
												.once('value')
												.then(snapshot => {
													console.log("user id");
													console.log(event.params.userId);
													return snapshot.val();
												})
												.then(customer => {
													console.log("customer ID");
													console.log(customer);
													const amount = val.amount;
													const idempotency_key = event.params.id;
													const currency = 'cad';
													const charge = {amount, currency, customer};

													console.log('charging the customers...');

													if (val.source !== null) charge.source = val.source;

													return stripe.charges.create(charge, {idempotency_key}, function(err, charge){
														if (err){
															console.log(err.Type);

															return event.data.adminRef.set(error);
														}
														return event.data.adminRef.set(charge);

													});
												})
												// .then(response => {
												// 	console.log('writing back to db');
												// 	if 
												// 	return event.data.adminRef.set(response);			
												// });
								});



exports.addPaymentToken = functions.database.ref('/users/{userId}/payments/sources/token').onWrite(event => {
	const source = event.data.val();
	console.log("this should be the token");
	console.log(event.data.val());
	console.log("adding new source to customer");
	if (source === null) return null;
	console.log("what is event.params.userId");
	console.log(event.params);
	console.log(event.params.userId);

	// get customerId
	return admin.database().ref(`/users/${event.params.userId}/payments/customerId`).once('value')
		   .then(snapshot => {
		   	console.log("snapshot in addPaymentToken");
		   	console.log(snapshot.val());
    return snapshot.val();
	}).then (customer => {
		console.log("customer inside addPaymentToken");
		console.log(customer);
		console.log("please let this be the token");
		console.log(source);

		// get customer object
		return stripe.customers.retrieve(customer);// , function(err, customer) {
			//console.log("GG something went wrong");

  		}).then(customerobj => {
  			console.log("got customer");

			if (customerobj.default_source == null) {
				console.log("whats with the source");
				console.log(source);

				return stripe.customers.createSource(customerobj.id, {source});

			}
			else {
				console.log("updating customer card");

				return stripe.customers.update(customerobj.id, {source})//, function(err, customer)
				// {
				// 	if (err) {
				// 		console.log(err);

				// 	}
				// 	console.log(customer);
				// 	return event.data.adminRef.set(customer);
				// });
			}
	}).then(response => {

		console.log("response from addPaymentToken");
		console.log(response);
		return event.data.adminRef.set(response);
	}, error => {
		console.log(error);
		return event.data.adminRef.parent.child('error').set(userFacingMessage(error));

	 	});
	});


// Update student balance everytime when they purchase a package
exports.updateBalance = functions.database.ref('/users/{sid}/payments/charges/{pid}').onUpdate(event => {
	const sid = event.params.sid;
	const id = event.params.pid;
	const amount = event.data.current.child('amount').val();
	const date = event.data.current.child('created').val();
	console.log("what is amount");
	console.log(event.data.current.child('amount').val());

	var addBalanceHistory = admin.database().ref("/users/" + sid + "/completeBalanceHistory/" + id);
	var ref = admin.database().ref("/users/" + sid + "/balance");

	ref.once("value").then(snapshot => {
		console.log("what is snapshot in balance");
		console.log(snapshot.val());
		var currentBalance = snapshot.val();
		// console.log(price);
		let amountString = amount.toString();
		console.log(amountString);

		let mins = admin.database().ref("/price/" + amountString);
		mins.once("value").then(snapshot => {
			console.log("what is the increment");
			var increment = snapshot.val();
			console.log(increment);
			currentBalance += increment;
			console.log(currentBalance);
			ref.set(currentBalance);
			return increment;
		}).then(timePurchased => {
				addBalanceHistory.set({
							price: amount,
							timePurchased: timePurchased,
							date: date
						});
		})
	})

})


exports.inactiveQuestion = functions.database.ref('/Request/active/{category}/{questionId}/rate').onUpdate(event => {
	
	console.log("getin");
	const questionId = event.params.questionId;
	const category = event.params.category;
	console.log(questionId);
	var ref = admin.database().ref("/Request/active/" + category +"/"+ questionId);
	console.log("inactiveQuestion triggered");
	ref.once("value").then(snapshot => {
		var changedQ = snapshot.val();
		console.log("what does it return");
		console.log(snapshot.val());
		console.log("removing node");
		ref.remove().then(function(){
			console.log("add to inactive");
			var reference = admin.database().ref("/Request/inactive/" + category +"/"+ questionId);
	   		reference.set(changedQ);
		});
	})
})


// Update student/tutor balance when they finish a session
exports.consumeBalance = functions.database.ref('/Request/inactive/{category}/{questionId}').onWrite(event => {

	const qid = event.params.questionId;
	const category = event.params.category;
	console.log(qid);
	console.log(category);

	var ref = admin.database().ref("/Request/inactive/" + category + "/" + qid);
	//const sid = ref.once("value").then(snapshot => {
	ref.once("value").then(snapshot => {
		console.log(snapshot.val());
		const sid = "+1" + snapshot.val().sid;
		console.log(sid);
		const tid = snapshot.val().tid;
		console.log(tid);
		const sessionTime = snapshot.val().duration;
		const rate = snapshot.val().rate;

		// Update student balance
		console.log("update student balance");
		console.log(sid);
		admin.database().ref("/users/" + sid + "/balance").once("value").then(snapshot => {
			console.log(snapshot.val());
			admin.database().ref("/users/" + sid + "/balance").set(snapshot.val() - sessionTime)
		})

		var today = new Date().getTime();

		var addBalanceHistory = admin.database().ref("/users/" + sid + "/completeBalanceHistory/" + qid);
		addBalanceHistory.set({
								sessionTime: sessionTime,
								date: today,
								category: category
							});

		// Update complete tutor balance + detailed breakdowns
		var completeTutorProfile = admin.database().ref("/tutors/" + tid);

		// Update tutor overall balance
		completeTutorProfile.child("balance").once("value").then(snapshot => {
			completeTutorProfile.child("balance").set(parseInt(snapshot.val()) + parseInt(sessionTime))
		});

		// Update tutor overall star
		completeTutorProfile.child("stars").once("value").then(snapshot => {
			completeTutorProfile.child("stars").set(parseInt(snapshot.val()) + parseInt(rate))
		});

		// Update tutor overall qnum
		completeTutorProfile.child("totalQuestionNum").once("value").then(snapshot => {
			completeTutorProfile.child("totalQuestionNum").set(parseInt(snapshot.val()) + 1)
		});

		// Add detailed balance history transaction
		var tutorBalanceHistory = admin.database().ref("/tutors/" + tid + "/completeBalanceHistory/" + qid);
		tutorBalanceHistory.set({
								sessionTime: sessionTime,
								date: today,
								category: category
							});

		// Update tutor monthly data
		var year = new Date().getFullYear();
		var month = new Date().getMonth();

		var tutorBalanceHistory = admin.database().ref("/tutors/" + tid + "/monthlyBalanceHistory/" + year + month);

		// Update monthly total
		tutorBalanceHistory.child("monthlyTotal").once("value").then(snapshot => {
			if (snapshot.val() == null){
				tutorBalanceHistory.child("monthlyTotal").set(0 + parseInt(sessionTime));
			}
			tutorBalanceHistory.child("monthlyTotal").set(parseInt(snapshot.val()) + parseInt(sessionTime));
		});

		// Update monthly stars
		tutorBalanceHistory.child("stars").once("value").then(snapshot => {
			if (snapshot.val() == null){
				tutorBalanceHistory.child("stars").set(0 + parseInt(rate));
			}
			tutorBalanceHistory.child("stars").set(parseInt(snapshot.val()) + parseInt(rate));
		});

		// Update monthly total question numbers
		tutorBalanceHistory.child("qnum").once("value").then(snapshot => {
			if (snapshot.val() == null){
				tutorBalanceHistory.child("qnum").set(1);
			}
			tutorBalanceHistory.child("qnum").set(parseInt(snapshot.val()) + 1);
		});
	})
})

// Pull category from database
exports.getCategory = functions.https.onRequest((req, res) => {
	var result = [];
	cors(req, res, () => {
		admin.database().ref("/category").once("value").then(function(snapshot) {
			snapshot.forEach(function(childSnapshot) {
				result.push({"category": childSnapshot.key,
							"subCate": childSnapshot.val()});
			});
		}).then(function(){
				res.status(200).send(JSON.stringify(result));
			});
	});
});

exports.cancel = functions.https.onRequest((req, res) => {


  // [START usingMiddleware]
  // Enable CORS using the `cors` express middleware.
  cors(req, res, () => {
  // [END usingMiddleware]
    // Reading date format from URL query parameter.
    // [START readQueryParam]
    /*
    let format = req.query.format;
    // [END readQueryParam]
    // Reading date format from request body query parameter
    if (!format) {
      // [START readBodyParam]
      format = req.body.format;
      // [END readBodyParam]
    }
    // [START sendResponse]
    const formattedDate = moment().format(format);
    console.log('Sending Formatted date:', formattedDate);
    res.status(200).send(formattedDate);*/
    // [END sendResponse]

    let qid = req.query.qid;
    let category = req.query.category;
    var ref = admin.database().ref("/Request/active/" + category +"/"+ qid);
	ref.on("value", function(snapshot) {
		if (snapshot.exists()) { 
			let url = snapshot.val().picURL
			const filePath = 'image/' + category + '/' + qid
			const bucket = gcs.bucket("instasolve-d8c55.appspot.com")
			const file = bucket.file(filePath)
			const pr = file.delete()
		    ref.remove();
		    ref.off();
		  }
	})

    res.status(200).send(req.query.category);
  });
});

exports.sendTutorNotification = functions.database.ref('/Request/active/{category}/{qid}').onCreate(event => {

	const category = event.params.category;
	return loadUsers(category).then(notification => {
		const payload = {
		  notification: {
		    title: `New ${category} question posted`,
		    body: `Please help my ${category} question`,
		    sound: 'default',
		    badge: '1'
		  }
		};
		console.log("back" + notification)
        return admin.messaging().sendToDevice(notification, payload);
    });
})

function loadUsers(category) {
	let tutorRef = admin.database().ref('/tutors');
	var notification = [];
	console.log(category);
    let defer = new Promise((resolve, reject) => {
        tutorRef.orderByChild("category/" + category).equalTo(true).on("value", function(snapshot)  {
            snapshot.forEach(function(data) {
                
                let token = data.val().token;
                console.log(token);
                if (token) {
                    notification.push(token);
              
                }
                
            });
            console.log("before" + notification)
            resolve(notification);
        }, (err) => {
            reject(err);
        });
    });
    return defer;
}

function userFacingMessage(error) {
  return error.type ? error.message : 'An error occurred, developers have been alerted';
}

// exports.readdata = functions.database.ref('/test').onWrite(event => {
// 	admin.database().ref('/test').once("value").then(snapshot => {
// 		console.log(snapshot.val());
// 	});
// })


