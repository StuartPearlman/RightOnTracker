$(function() {

    // Change train stops for each line selected
    $('#select-line').change(function() {

        var id = $(this).val();

        $(".convenient").addClass("hidden");

        $("#" + id).removeClass("hidden");
    });

    // Delete account and confirmation
    $("#delete-account-form").submit(function(event) {

        if ($("#delete-account").val() == "Are you sure?") {

            return true;

        } else {

            $("#delete-account").val("Are you sure?");

            return false;
        };
    });

    // Cancel if user clicks outside delete button
    $(document).click(function(event) {

        if (!$(event.target).is('#delete-account')) {

            $("#delete-account").val("Delete account");
        };
    });

    // Delete a stop (use document scope b/c of AJAX call)
    $(document).on("click", ".pure-button.delete.unique", function(event) {

        event.preventDefault();
        
        var id = $("#user").val();

        $.ajax({

            url: $(".delete-stop").attr("action"),

            method: 'POST',

            dataType: 'text',

            success: function(data) {

                $('#partials-div').load('/users/' + id + '/stops');
            },

            error: function(data) {

                $("#stop-table-header").text("An error occurred.");

                setTimeout(
                    function() {
                        $('#stop-table-header').text("Your stops");
                    }, 3500);
            }
        });
    });

    // Add a stop and validate params
    $("#new-stop").submit(function(event) {

        event.preventDefault();

        if (!$("#select-time").val() || $("input:checkbox:checked").length == 0) {

            $("#stop-header").text("Please enter a time and date.")

            restoreStopHeader();

        } else {

            var id = $("#user").val();

            $.ajax({
                
                url: '/users/' + id + '/trains/create',
                
                method: 'POST',
                
                type: 'json',
                
                data: {
                    
                    time: $("#select-time").val(),
                    
                    line: $("#select-line").val(),
                    
                    // Workaround to dynamically match stop with line
                    stop: $("#select-stop-" + $("#select-line").val().toLowerCase()).val(),
                    
                    days: {

                        monday: $("#monday:checked").val(),
                        
                        tuesday: $("#tuesday:checked").val(),
                        
                        wednesday: $("#wednesday:checked").val(),
                        
                        thursday: $("#thursday:checked").val(),
                        
                        friday: $("#friday:checked").val(),
                        
                        saturday: $("#saturday:checked").val(),
                        
                        sunday: $("#sunday:checked").val()
                    }
                },

                success: function(data) {
                    
                    $("#stop-header").text(data);
                    
                    $('#partials-div').load('/users/' + id + '/stops');
                    
                    $("#new-stop").trigger('reset');
                    
                    // Default back to red line
                    $(".convenient").addClass("hidden"); 
                    
                    $("#Red").removeClass("hidden");
                    
                    restoreStopHeader();
                },

                error: function(data) {
                    
                    //Prevent error dumps from rendering
                    if (data["responseText"].length > 100) {
                        
                        $("#stop-header").text("An error has occured.");
                    
                    } else {
                        
                        $("#stop-header").text(data["responseText"]);
                    };   

                    restoreStopHeader();
                }
            });
        };
    });

    // Define functions
    function restoreStopHeader() {

        setTimeout(

            function() {
                
                $('#stop-header').text("Add a new stop");
            },
        
        3500);
    };

});