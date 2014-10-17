$(function() {

    $("#receive-pin").submit(function(event) {
        event.preventDefault();
        var originalText = $('#message-center').text();
        var height = $('#message-center').height();
        var width = $('#message-center').width();

        $.ajax({
            url: $(this).attr("action"),
            method: 'POST',
            success: function(data) {
                $('#message-center').css({
                    "height": height,
                    "width": width
                });
                $('#message-center').text(data);
                setTimeout(
                    function() {
                        $('#message-center').css({
                            "height": '',
                            "width": ''
                        });
                        $('#message-center').text(originalText);
                    }, 3500);
                $("#pin").focus();
            },
            error: function(data) {
                $('#message-center').css({
                    "height": height,
                    "width": width
                });
                $('#message-center').text("An error occurred.");
                setTimeout(
                    function() {
                        $('#message-center').css({
                            "height": '',
                            "width": ''
                        });
                        $('#message-center').text(originalText);
                    }, 3500);
            }
        });
    });

    $('#pin').keypress(function(event) {
        // stop entering characters and backspace
        if (event.which != 8 && isNaN(String.fromCharCode(event.which)) || event.keyCode == 32) {
            event.preventDefault();
        }
    });

    $("#submit-pin").submit(function(event) {
        if ($('#pin').val().length < 4) {
            event.preventDefault();
        } else {
            event.preventDefault();
            var originalText = $('#message-center').text();
            var height = $('#message-center').height();
            var width = $('#message-center').width();


            $.ajax({
                url: $(this).attr("action"),
                method: 'POST',
                type: 'json',
                data: {
                    pin: $("#pin").val()
                },
                success: function(data) {
                    window.location.href = data;
                },
                error: function(data) {
                    $('#message-center').css({
                        "height": height,
                        "width": width
                    });
                    $('#message-center').text(data['responseText']);
                    setTimeout(
                        function() {
                            $('#message-center').css({
                                "height": '',
                                "width": ''
                            });
                            $('#message-center').text(originalText);
                        }, 3500);
                }
            });
        };
    });
});