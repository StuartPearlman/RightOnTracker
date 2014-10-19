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

        var winHeight = $(window).height();

        if (winHeight < 500) {

            $(".align").css('height', (winHeight + 500).toString());
        };
    };
});