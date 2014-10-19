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

        $(".align").css('height', (window.screen.availHeight).toString());
        $(".align").css('width', (window.screen.availWidth).toString());
    };
});