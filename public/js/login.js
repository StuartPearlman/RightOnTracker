$(function() {
    $('#phone-number').keypress(function(event) {

        // stop entering characters and backspace
        if (event.which != 8 && isNaN(String.fromCharCode(event.which)) || event.keyCode == 32) {
            event.preventDefault();
        }
    });

    $('#continue').submit(function(event) {
        if ($('#phone-number').val().length < 10) {
            console.log($('#phone-number').val().length);
            event.preventDefault();
        } else {
            $(this).unbind('submit');
        };
    });

});