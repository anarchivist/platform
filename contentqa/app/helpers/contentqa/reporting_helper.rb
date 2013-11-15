module Contentqa
  module ReportingHelper

    def nice_time(t)
      Time.parse(t).to_s
    end

    def report_link(report_file, ingest, report_type)
      if report_file
        link_to "Download", {:controller => "reporting", :action => "download", :id => ingest['_id'], :report_type => report_type}
      else
        link_to "Create Report", {:controller => "reporting", :action => "create", :remote => true, :id => ingest['_id'], :report_type => report_type}
      end
    end

    def report_details(report_file)
      if report_file        
        number_to_human_size(report_file.size) + " - " + report_file.mtime.to_s if report_file        
      end
    end

  end
end
