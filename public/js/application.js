function load(script) {
    document.write('<script src=/js/' + script + ' ' + 'type=text/javascript></script>');
};

//Load all dependencies
load("profile.js");
load("login.js");
load("confirm.js");


$(function() {

    perfectFit();

    $(window).resize(function() {

        perfectFit();
    });

    function perfectFit() {
        
        if ($(window).width() < 500) {
            
            $("a.navbar-brand").replaceWith("<a class='navbar-brand' href='/''><i>Tracker</i></a>");
            $('#back').css('margin-right', "0em");
            $("#phone-number,#pin").css("font-size", "1.0em");
        
        } else {
            
            $("a.navbar-brand").replaceWith("<a class='navbar-brand' href='/''>RightOn<i>Tracker</i></a>");
            $('#back').css('margin-right', ".8em");
            $("#phone-number,#pin").css("font-size", "1.5em");

        };

        $(".align").css('height', ($(document).height()).toString());
    };
});