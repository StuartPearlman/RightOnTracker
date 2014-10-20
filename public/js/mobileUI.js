$(function() {

    perfectFit();

    $(window).resize(function() {

        perfectFit();
    });

    function perfectFit() {
        
        if ($(window).width() < 500) {
            
            $("a.navbar-brand").replaceWith("<a class='navbar-brand' href='/''>R.O.<i>Tracker</i></a>");
            $('#back').css('margin-right', "0em");
            $("#phone-number,#pin").css("font-size", "1.0em");
            $("th,td,#delete-train").css("font-size", ".5em");

        
        } else {
            
            $("a.navbar-brand").replaceWith("<a class='navbar-brand' href='/''>RightOn<i>Tracker</i></a>");
            $('#back').css('margin-right', ".8em");
            $("#phone-number,#pin").css("font-size", "1.5em");
            $("th,td,#delete-train").css("font-size", "1em");

        };

        $(".align").css('height', ($(document).height()).toString());
    };
});