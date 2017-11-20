$(document).ready(function(){
	getUserFromSession();
	$('[data-toggle="offcanvas"]').click(function(){
		$('#side-menu').toggleClass('hidden-xs');
	});
});

function getUserFromSession() {
		$.ajax({
			url: "/userinsession",
			type: "GET",
			dataType: "json",
			contentType: "application/json; charset=utf-8",
			success: function(response) {
				if (response['type'] != "" && response['email'] != "") {
					$(".ututor_user").text(response['username'] + " (" + response['email'] + ")");
				}
				else {
					//window.location.href = "../index.html";
				}
			},
			error: function (xhr) {
				alert(xhr.responseText);
			}
        });
        
    }
































