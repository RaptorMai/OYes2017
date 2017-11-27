const functions = require('firebase-functions');
var admin = require("firebase-admin");

var serviceAccount = require("./test-b988b-firebase-adminsdk-2p4c0-96bff53022.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://test-b988b.firebaseio.com"
});

// Get a database reference to our posts
var db = admin.database();
// var ref = db.ref("/hahahah");

// // Attach an asynchronous callback to read the data at our posts reference
// ref.on("value", function(snapshot) {
//   console.log(snapshot.val());
// }, function (errorObject) {
//   console.log("The read failed: " + errorObject.code);
// });

// var uid = "7svrPaWse5Ww2rxOZAlZUnsBeq82"
// admin.auth().getUser(uid)
//   .then(function(userRecord) {
//     // See the UserRecord reference doc for the contents of userRecord.
//     console.log("Successfully fetched user data:", userRecord.toJSON());
//   })
//   .catch(function(error) {
//     console.log("Error fetching user data:", error);
//   });

//  var email = "123@gmail.com"
//  admin.auth().getUserByEmail(email)
//   .then(function(userRecord) {
//     // See the UserRecord reference doc for the contents of userRecord.
//     console.log("Successfully fetched user data:", userRecord.toJSON());
//   })
//   .catch(function(error) {
//     console.log("Error fetching user data:", error);
//   });

//   admin.auth().createUser({
//   email: "cooler@example.com",
//   emailVerified: false,
//   phoneNumber: "+11234567890",
//   password: "secretPassword",
//   displayName: "John Doe",
//   photoURL: "http://www.example.com/12345678/photo.png",
//   disabled: false
// })
//   .then(function(userRecord) {
//     // See the UserRecord reference doc for the contents of userRecord.
//     console.log("Successfully created new user:", userRecord.email);
//     var tid = userRecord.email;
//     tid = tid.replace("@", ""); 
//     tid = tid.replace(/\./g, ""); 
//     console.log(tid)
//     admin.database().ref(`/tutors/${tid}/categories`).set("computer science", function(error){
//        if (error) {
//         console.log("New user profilepicURL cannot be created: " + error);
//        };
//        return console.log("profilepicURL setup");
//     });
//   })
//   .catch(function(error) {
//     console.log("Error creating new user:", error);
//   });

exports.addtutor = function(req, res){
	console.log("============ updateuser ==============");
	console.log(req.body)
	var tutorEmail = req.query.email;
	var tutorPwd = req.query.password;
	var tutorCategories = req.query.categories;

	admin.auth().createUser({
		email: tutorEmail,
		emailVerified: false,
		password: tutorPwd,
		disabled: false
	}).then(function(user){
		console.log("Successfully created new user: ", user.email);
		var tid = user.email;
		tid = tid.replace("@", ""); 
    	tid = tid.replace(/\./g, "");

    	for (i=0; i<tutorCategories.length; i++){
        	admin.databse().ref(`/tutors/${tid}/category/${tutorCategories[i]}`).set("true", function(error){
        		if (error){
        			console.log("Create new user failed: " + error);
        		};
        		return console.log("Successfully inputed correct information to tutor!");
        	});
    	}
	})
	.catch(function(error){
		console.log("Error creating new user: ", error);
	});
}












