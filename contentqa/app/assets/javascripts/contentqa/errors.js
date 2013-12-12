$(".table:first").show();

$("a").bind("click", function() {
    $(".table").hide();
    $("#" + $(this).attr("id") + "_table").show();
});
