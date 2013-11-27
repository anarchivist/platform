// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$("#progressbar").progressbar().height(20).hide();

$('#check_all').on("click", function() {
    $('input[type="checkbox"]').click();
});

$('#create').on("click", function() {
    var reports = $('input[name="reports[]"]:checked').map(function() {
      return $(this).val();
    }).get();
    if (reports.length) {
        $("#progressbar").progressbar().height(20).show();
        $(this).prop("disabled", true);
        $('#check_all').prop("disabled", true);
        var ingest_id = $('#id').val();
        var count = 0;
        var total = reports.length;
        reports.forEach(function(report) {
            $.ajax({
                url: "/qa/reporting/create",
                data: {id: ingest_id, report: report},
                success: function() {
                    count++;
                    $("#progressbar").progressbar("value", (count/total*100));
                    if (count == total) {
                        window.location.replace("/qa/reporting/provider?id=" + ingest_id);
                    }
                }
            });
        });
    }
});
