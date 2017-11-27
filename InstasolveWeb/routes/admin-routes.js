let express = require('express');
let router = express.Router();
const functions = require('firebase-functions');
let admin = require("firebase-admin");

var serviceAccount = require("./test-b988b-firebase-adminsdk-2p4c0-96bff53022.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://test-b988b.firebaseio.com"
});

// Get a database reference to our posts
var db = admin.database();


router.post('/', function(req, res, next){
	console.log(req.body.email);
});


exports.addtutor = function(req, res){
	console.log("============ updateuser ==============");
	var tutorEmail = req.body.email;
	var tutorPwd = req.body.password;
	var tutorCategories = req.body.categories;
	console.log("adding email: " + tutorEmail);
	console.log("adding password: " + tutorPwd);
	console.log("adding tutorCategories: " + tutorCategories);

	admin.auth().createUser({
		email: tutorEmail,
		emailVerified: false,
		password: tutorPwd,
		disabled: false
	}).then(function(user){
		console.log("Successfully created new user: ", user.email);
		var tid = user.email;
		console.log(tid);
		tid = tid.replace("@", "");
    	tid = tid.replace(/\./g, "");

    	for (i=0; i<tutorCategories.length; i++){
        	db.ref(`/tutors/${tid}/category/${tutorCategories[i]}`).set("true", function(error){
        		if (error){
        			console.log("Create new user failed: " + tutorEmail + " " + error);
        		};

        	});
    	}
        console.log("Successfully created tutor: " + tutorEmail);
		return res.send("Successfully created tutor: " + tutorEmail);
	})
	.catch(function(error){
		console.log("Error creating new user: ", error);
		return res.send("Fail to create tutor: " + tutorEmail +" "+ error);
	});
}












