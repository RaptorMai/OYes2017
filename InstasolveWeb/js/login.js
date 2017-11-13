/*  ======== User login =================  */
function login(){
	var email = $("#emailText").val();
	var password = $("#passwordText").val();

	console.log(email);

	var data = {
		"email": email,
		"password": password
	};

	$.ajax({
		url:"/login",
		type:"GET",
		dataType:"text",
		contentType:"application/json; charset=utf-8",
		data: data,
		success: function(response){
			if (response == "wrongPwd"){
				alert("Wrong Password: Please Re-Enter");
			} else if (response == "invalidEmail"){
				alert("Invalid Email: Permission Denied");
			} else {
				$("html").html(response);
			}
		}, error: function (xhr){
			alert(xhr.responseText);
		}
	});
}


































