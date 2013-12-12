require_dependency "contentqa/application_controller"
require "contentqa/reports"

module Contentqa

  class ReportingController < ApplicationController
    include ReportingHelper

    def index
      @providers = Reports.find_last_ingests
    end

    def provider
      @ingest = Reports.find_ingest params[:id]
      @reports = Hash.new
      Reports.find_report_types.each do |type|
        @reports[type] = {:file => Reports.get_report(@ingest['_id'], type),
                          :job => Delayed::Job.find_by_queue("#{params[:id]}_#{type}")}
      end

      respond_to do |format|
        format.html
        format.js {render "report_status", :reports => @reports, :ingest => @ingest}
      end
    end

    def errors
      @ingest = Reports.find_ingest params[:id]
    end

    def create
      id = params[:id]
      type = params[:report_type]
      Reports.delay(:queue => "#{id}_#{type}").create_report(id, type)
      render nothing: true
    end

    def download
      path = Reports.report_path params[:id], params[:report_type]
      if path
        send_file path, :type => "text/csv", :filename => params[:report_type]
      else
        render status: :forbidden, text: "Access denied"
      end
    end
      
  end
end
