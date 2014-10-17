$(function() {

    // Stop from entering invalid characters
    $('#phone-number').keypress(function(event) {

        if (event.which != 8 && isNaN(String.fromCharCode(event.which)) || event.keyCode == 32) {
            event.preventDefault();
        };
    });

    //Validate phone number
    $('#continue').submit(function(event) {

        var height = $(".lead").height();
        var width = $(".lead").width();

        if ($('#phone-number').val().length < 10) {

            freezePhoneDiv(event, height, width);

            $('.lead').text("Phone number should be ten digits.");

            restorePhoneDiv();

        } else if ($('#phone-number').val().charAt(0) == "1") {

            freezePhoneDiv(event, height, width);

            $('.lead').text("Area code and number only, please.");

            restorePhoneDiv();

        } else {

            $(this).unbind('submit');
        };
    });

    // Define functions
    function restorePhoneDiv() {

        setTimeout(

            function() {
                
                $('.lead').css({
                    "height": '',
                    "width": ''
                });

                $('.lead').text("Please enter your cell phone number below:");
            },
        
        3500);
    };

    function freezePhoneDiv(event, height, width) {
        
        event.preventDefault();
        
        $('.lead').css({
            "height": height,
            "width": width
        });
    };

});