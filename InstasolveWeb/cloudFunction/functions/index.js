const functions = require('firebase-functions');
const admin = require('firebase-admin');
const cors = require('cors')({origin: true});
const gcs = require('@google-cloud/storage')()

admin.initializeApp(functions.config().firebase);


exports.createStripeUser = functions.auth.user().onCreate(event => {

 const data = event.data;
 // Check if a customer is a student
 console.log(data.phoneNumber);
 if (data.phoneNumber != null){
  /*var maxUser = 100;
  var refNumUser = admin.database().ref("/globalConfig/numCurrentUser");
  refNumUser.once("value").then(snapshot => {
   var numUser = snapshot.val();
   numUser += 1
   console.log("Number of current user");
   console.log(numUser);
   refNumUser.set(numUser, function(error){
    if (error) {
     console.log("Set number of current users" + error);
    };
      
   });
   if (numUser >= maxUser){
    admin.database().ref("/globalConfig/canRegister").set(false, function(error){
     if (error) {
      console.log("Can't set " + error);
     }
    })
   }
  })*/

  admin.database().ref(`/users/${data.phoneNumber}/email`).set("Please add email", function(error){
     if (error) {
      console.log("New user email cannot be created: " + error);
     };
     return console.log("email setup");
  });
  admin.database().ref(`/users/${data.phoneNumber}/username`).set("Please add username", function(error){
     if (error) {
      console.log("New user username cannot be created: " + error);
     };
     return console.log("name setup");
  });
  admin.database().ref(`/users/${data.phoneNumber}/grade`).set("Please select grade", function(error){
     if (error) {
      console.log("New user grade cannot be created: " + error);
     };
     return console.log("grade setup");
  });
  admin.database().ref(`/users/${data.phoneNumber}/profilepicURL`).set("", function(error){
     if (error) {
      console.log("New user profilepicURL cannot be created: " + error);
     };
     return console.log("profilepicURL setup");
  });

  admin.database().ref(`/users/${data.phoneNumber}/discountAvailable`).set(5, function(error){
     if (error) {
      console.log("New user discountAvailable cannot be created: " + error);
     };
     return console.log("discountAvailable setup");
  });
 }
 // if phoneNumber does not exist, means user is a tutor
 // Here we can set up tutor in the future
 else { 
  var tid = data.email;
  tid = tid.replace("@", ""); 
  tid = tid.replace(/\./g, ""); 
  console.log(tid)
  admin.database().ref(`/tutors/${tid}/profilepicURL`).set("", function(error){
     if (error) {
      console.log("New user profilepicURL cannot be created: " + error);
     };
     return console.log("profilepicURL setup");
  });
  admin.database().ref(`/tutors/${tid}/username`).set("", function(error){
     if (error) {
      console.log("New user username cannot be created: " + error);
     };
     return console.log("username setup");
  });
  admin.database().ref(`/tutors/${tid}/balance`).set(0, function(error){
     if (error) {
      console.log("New user balance cannot be created: " + error);
     };
     return console.log("balance setup");
  });
  admin.database().ref(`/tutors/${tid}/stars`).set(0, function(error){
     if (error) {
      console.log("New user stars cannot be created: " + error);
     };
     return console.log("stars setup");
  });
  admin.database().ref(`/tutors/${tid}/totalQuestionNum`).set(0, function(error){
     if (error) {
      console.log("New user totalQuestionNum cannot be created: " + error);
     };
     return console.log("totalQuestionNum setup");
  });
  admin.database().ref(`/tutors/${tid}/email`).set(data.email, function(error){
     if (error) {
      console.log("New user email cannot be created: " + error);
     };
     return console.log("email setup");
  });
  return console.log("This is a tutor, so no need to create stripe account");
 }
});