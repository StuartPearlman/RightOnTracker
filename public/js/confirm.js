$(function() {

    // Receive pin through AJAX call
    $("#receive-pin").submit(function(event) {
        
        event.preventDefault();
        var height = $('#message-center').height();
        var width = $('#message-center').width();

        $.ajax({
            
            url: $(this).attr("action"),
            
            method: 'POST',
            
            success: function(data) {
              
                freezeMessageCenter(height, width);
            
                $('#message-center').text(data);
                
                restoreMessageCenter();
                
                $("#pin").focus();
            },
            
            error: function(data) {
                
                freezeMessageCenter(height, width);
               
                $('#message-center').text("An error occurred.");
                
                restoreMessageCenter();
            }
        });
    });

    // Stop from entering invalid characters
    $('#pin').keypress(function(event) {
        
        if (event.which != 8 && isNaN(String.fromCharCode(event.which)) || event.keyCode == 32) {
            event.preventDefault();
        }
    });

    // Submit pin AJAX validation
    $("#submit-pin").submit(function(event) {

        if ($('#pin').val().length < 4) {

            event.preventDefault();

        } else {

            event.preventDefault();
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

                    freezeMessageCenter(height, width);

                    //Prevent big error messages from rendering
                    if (data["responseText"].length > 100) {
                        
                        $("#message-center").text("An error has occured.");
                    
                    } else {
                        
                        $("#message-center").text(data["responseText"]);
                    };   

                    restoreMessageCenter();

                    $("#pin").focus();
                }
            });
        };
    });

    // Define functions
    function freezeMessageCenter(height, width) {

        $('#message-center').css({
            "height": height,
            "width": width
        });
    };

    function restoreMessageCenter() {
        
        setTimeout(
            
            function() {

                $('#message-center').css({
                    "height": '',
                    "width": ''
                });

                $('#message-center').text("Enter your pin below or click 'Receive Pin' to be texted a new one.");
            }, 

        3500);
    };

});