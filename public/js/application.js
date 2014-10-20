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
            $("a.navbar-brand").text("Tracker")
        } else {
            $("a.navbar-brand").replaceWith("<a class='navbar-brand' href='/''>RightOn<i>Tracker</i></a>");
        }

        $(".align").css('height', ($(document).height()).toString());
    };
});