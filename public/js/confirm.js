$(function() {
    $("#receive-pin").submit(function(event) {
        event.preventDefault();
        var id = $(".hidden").val();
        var originalText = $('.lead').html();

        $.ajax({
            url: '/users/' + id + '/code',
            method: 'POST',
            success: function(data) {
                $('#message-center').replaceWith("<p id='message-center'><br>" + data + "<br><br></p>");
                setTimeout(
                    function() {
                        $('#message-center').replaceWith(originalText);
                    }, 3500);
            },
            error: function(data) {
                $('#message-center').replaceWith("<p id='message-center'><br>" + data + "<br><br></p>");
                setTimeout(
                    function() {
                        $('#message-center').replaceWith(originalText);
                    }, 3500);
            }
        });
    });

    $("#submit-pin").submit(function(event) {
        event.preventDefault();
        var id = $(".hidden").val();
        var originalText = $('.lead').html();

        $.ajax({
            url: '/users/' + id + '/confirm',
            method: 'POST',
            type: 'json',
            data: {
            	pin: $("#pin").val()
            },
            success: function(data) {
              	window.location.href = data;
            },
            error: function(data) {
                $('#message-center').replaceWith("<p id='message-center'>" + data['responseText'] + "<br><br></p>");
                setTimeout(
                    function() {
                        $('#message-center').replaceWith(originalText);
                    }, 3500);
            }
        });
    });
});