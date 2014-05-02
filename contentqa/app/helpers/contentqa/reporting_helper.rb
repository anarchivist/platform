module Contentqa
  module ReportingHelper

    def nice_process(process)
      process.tr("_", " ").capitalize
    end

    def nice_est_time(t)
      t = Time.parse(t) if t.instance_of?(String)
      t.in_time_zone("Eastern Time (US & Canada)").strftime("%Y-%m-%d %H:%M:%S")
    end

    def job_start(job)
      nice_est_time(job.created_at)
    end

    def report_link(report_file, generate_job, ingest_id, report_type)
      if report_type == "all"
        text = "Download All"
      else
        text = "Download"
      end
      if report_file
        link_to text, {:controller => "reporting", :action => "download", :id => ingest_id, :report_type => report_type}
      elsif generate_job
        "Generating."
      end
    end

    def disable_report_checkbox?(report_file)
      not report_file or not report_file.instance_of?(String)
    end

    def report_details(report_file, generate_job)
      if report_file        
        number_to_human_size(report_file.size) + " - " + report_file.mtime.to_s if report_file 
      elsif generate_job
        "Started on #{job_start(generate_job)}"
     end
    end

    def error_link(ingest)
      if not get_errors(ingest).empty?
        return link_to "Errors", {:controller => "reporting", :action => "errors", :id => ingest['_id']}
      end

      return nil
    end

    def get_errors(ingest)
      errors = Hash.new
      ingest.each do |k, v|
        if k.end_with?("_process") and not v["error"].nil? and not v["error"].empty?
          errors[k] = v["error"]
        end
      end
      return errors
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

    def global_reports_link
      link_to_if !Reports.ingestion_running?, "Global Reports", {:controller => "reporting", :action => "global", :id => Reports.get_global_reports_id}
    end

    def get_enrich_process(ingest)
      enrich_process = ingest.to_hash.fetch('poll_storage_process', {})['status'].nil? ? 'enrich_process' : 'poll_storage_process'
    end

  end
end
