firebase.auth().onAuthStateChanged(function(user) {
  if (user) {
  	// User is signed in.
  	$(".login-page").hide();
  	setTimeout(function () {
    $(".login-cover").hide();
	}, 1000);
	$("#loginBtn").show();
	$("#login-progress").hide();
  } else {
    // No user is signed in.
    $(".login-cover").hide();
    $(".login-page").show();
  }
});


/* LOGIN PROCESS */
$("#loginBtn").click(
	function(){
		var email = $("#emailText").val();
		var password = $("#passwordText").val();

		if (email != "" && password != ""){
			$("#loginBtn").hide();
			$("#login-progress").show();
			firebase.auth().signInWithEmailAndPassword(email, password).then(function() {
  				// Sign-in successful.
			}).catch(function(error) {
			  // Handle Errors here.
			  var errorCode = error.code;
			  var errorMessage = error.message;
			  $("#loginError").show().text(errorMessage);
			  $("#loginBtn").show();
			  $("#login-progress").hide();
			});
		} else {
			alert("Input cannot be empty");
		}
	}
);


/* LOGOUT PROCESS */
$("#logoutBtn").click(
	function(){
		firebase.auth().signOut().then(function() {
  			// Sign-out successful.
		}).catch(function(error) {
  			// An error happened.
  			var errorCode = error.code;
  			var errorMessage = errorMessage;
  			alert(errorMessage);
		});

	}
);









