$(document).ready(function () {
  

    var navListItems = $('div.setup-panel div a'),
            allWells = $('.setup-content'),
            allNextBtn = $('.nextBtn');

            //implement previous button
            allPreBtn = $('.preBtn');

    allWells.hide();

    navListItems.click(function (e) {
        e.preventDefault();
        var $target = $($(this).attr('href')),
                $item = $(this);

        if (!$item.hasClass('disabled')) {
            navListItems.removeClass('btn-primary').addClass('btn-default');
            $item.addClass('btn-primary');
            allWells.hide();
            $target.show();
            $target.find('input:eq(0)').focus();
        }
    });

    allNextBtn.click(function(){
        var curStep = $(this).closest(".setup-content"),
            curStepBtn = curStep.attr("id"),
            nextStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().next().children("a"),
            curInputs = curStep.find("input[type='text'],input[type='url']"),
            isValid = true;

        $(".form-group").removeClass("has-error");
        for(var i=0; i<curInputs.length; i++){
            if (!curInputs[i].validity.valid){
                isValid = false;
                $(curInputs[i]).closest(".form-group").addClass("has-error");
            }
        }

        if (isValid)
            nextStepWizard.removeAttr('disabled').trigger('click');
    });


    $('div.setup-panel div a.btn-primary').trigger('click');
});

function appendText() {
    var txt2 = $("<button></button>").text("Computer Science");  // Create text with jQuery
    $("#tagsPanel").append(txt2);     // Append new elements
}



function tutorRegister(){
    var email = $(".email-input").val();
    var password = "123456";
    var cur_selection = $('.multiple-selection').select2('data');
    var selectedTags = [];
    for (i=0; i<cur_selection.length; i++){
        selectedTags.append(cur_selection[i].text);
    }

    var data = {
        "email": email,
        "password": password,
        "categories": selectedTags
    }

    $.ajax({
        url: "/comfirmAddTutor".
        type: "POST",
        dataType: "text",
        contentType: "application/json; charset=utf_8",
        data: data,
        success: function(response){
            alert(response);
        },
        error: function(xhr){
            alert(xhr.responseText);
        }
    });
}




























