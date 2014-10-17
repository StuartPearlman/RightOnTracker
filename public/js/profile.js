$(function() {

    // Change train stops for each line
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

    $(document).click(function(event) {
        if (!$(event.target).is('#delete-account')) {
            $("#delete-account").val("Delete account");
        };
    });

    // Delete a stop
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

    // Add a stop
    $("#new-stop").submit(function(event) {
        event.preventDefault();

        if (!$("#select-time").val() || $("input:checkbox:checked").length == 0) {
            $("#stop-header").text("Please enter a time and date.")
            setTimeout(
                function() {
                    $('#stop-header').text("Add a new stop");
                }, 3500);
        } else {
            var id = $("#user").val();

            $.ajax({
                url: '/users/' + id + '/trains/create',
                method: 'POST',
                type: 'json',
                data: {
                    time: $("#select-time").val(),
                    line: $("#select-line").val(),
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
                    setTimeout(
                        function() {
                            $('#stop-header').text("Add a new stop");
                        }, 3500);
                },
                error: function(data) {
                    $("#stop-header").text(data['responseText']);

                    setTimeout(
                        function() {
                            $('#stop-header').text("Add a new stop");
                        }, 3500);

                }
            });
        };
    });

});