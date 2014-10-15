$(function() {

    $('#select-line').change(function() {
        var id = $(this).val();
        $(".convenient").addClass("hidden");
        $("#" + id).removeClass("hidden");
    });

    $("#delete").click(function(event){
    	event.preventDefault();
    	$(this).val("Are you sure?");
    	$(this).attr("id", "confirm");
    	$(this).unbind('click');
    });
});