function load(script) {
    document.write('<script src=/js/' + script + ' ' + 'type=text/javascript></script>');
};

//Load all dependencies
load("profile.js");
load("login.js");
load("confirm.js");