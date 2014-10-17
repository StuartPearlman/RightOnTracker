$(function() {
    $('#phone-number').keypress(function(event) {

        // stop entering characters and backspace
        if (event.which != 8 && isNaN(String.fromCharCode(event.which)) || event.keyCode == 32) {
            event.preventDefault();
        }
    });

    $('#continue').submit(function(event) {
        var height = $(".lead").height();
        var width = $(".lead").width();

        if ($('#phone-number').val().length < 10) {
            event.preventDefault();
            $('.lead').css({
                "height": height,
                "width": width
            });
            $('.lead').text("Phone number should be ten digits.");
            setTimeout(
                function() {
                    $('.lead').css({
                        "height": '',
                        "width": ''
                    });
                    $('.lead').text("Please enter your cell phone number below:");
                }, 3500);

        } else if ($('#phone-number').val().charAt(0) == "1") {
            event.preventDefault();
            $('.lead').css({
                "height": height,
                "width": width
            });
            $('.lead').text("Area code and number only, please.");
            setTimeout(
                function() {
                    $('.lead').css({
                        "height": '',
                        "width": ''
                    });
                    $('.lead').text("Please enter your cell phone number below:");
                }, 3500);
        } else {
            $(this).unbind('submit');
        };
    });
});