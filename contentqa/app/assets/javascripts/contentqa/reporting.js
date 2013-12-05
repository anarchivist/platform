// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$('#check_all').on("click", function() {
    $('input[type="checkbox"]').click();
});

$('#create').on("click", function() {
    var report_types = $('input[name="reports[]"]:checked').map(function() {
      return $(this).val();
    }).get();
    if (report_types.length) {
        $(this).prop("disabled", true);
        $('#check_all').prop("disabled", true);
        var ingest_id = $('#id').val();
        var count = 0;
        var total = report_types.length;
        report_types.forEach(function(report_type) {
            $.ajax({
                url: "/qa/reporting/create",
                data: {id: ingest_id, report_type: report_type},
                success: function() {
                    count++;
                    $("." + report_type + "_link").html("Creating...");
                    if (count == total) {
                        window.location.replace("/qa/reporting/provider?id=" + ingest_id);
                    }
                }
            });
        });
    }
});
