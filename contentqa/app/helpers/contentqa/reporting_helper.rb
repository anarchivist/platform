module Contentqa
  module ReportingHelper

    def nice_time(t)
      Time.parse(t).to_s
    end

    def report_link(report_file, ingest, report_type)
      if report_file
        link_to "Download", {:controller => "reporting", :action => "download", :id => ingest['_id'], :report_type => report_type}
      end
    end

    def report_details(report_file)
      if report_file        
        number_to_human_size(report_file.size) + " - " + report_file.mtime.to_s if report_file 
      end
    end

    def error_link(ingest)
      if get_errors(ingest)
        return link_to "Errors", {:controller => "reporting", :action => "errors", :id => ingest['_id']}
      end

      return nil
    end

    def get_errors(ingest)
      ingest.each do |k, v|
        if k.end_with?("_process") and not v["error"].nil? and not v["error"].empty?
          return v["error"]
        end
      end
      return nil
    end

    def running?(ingest)
      ingest.each do |k, v|
        if k.end_with?("_process") and v["status"] == "running"
          return true
        end
      end
      return false
    end

    def report_page_link(ingest)
      if running?(ingest)
        "Not ready"
      else
        link_to "Reports", {:controller => "reporting", :action => "provider", :id => ingest['_id']}
      end
    end

  end
end
