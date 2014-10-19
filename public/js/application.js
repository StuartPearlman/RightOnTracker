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

        var winHeight = window.screen.availHeight;

        if (winHeight < 1000) {

            $(".align").css('height', (winHeight + 200).toString());
        };
    };
});