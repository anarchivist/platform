$(".error_table:first").show();

$(".error_link").bind("click", function() {
    $(".table").hide();
    $("#" + $(this).attr("id") + "_table").show();
});
