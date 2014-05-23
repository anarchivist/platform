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
      Reports.find_report_types("provider").each do |type|
        @reports[type] = {:file => Reports.get_report(@ingest['_id'], type),
                          :job => Delayed::Job.find_by_queue("#{params[:id]}_#{type}")}
      end
      if Reports.all_created?(params[:id])
        @all_reports = Reports.get_zipped_reports(@ingest['_id'], @ingest['provider'])
      else
        @all_reports = false
      end

      respond_to do |format|
        format.js
        format.html
      end
    end

    def global
      @global_reports_id = Reports.get_global_reports_id
      @reports = Hash.new
      Reports.find_report_types("global").each do |type|
        @reports[type] = {:file => Reports.get_report(@global_reports_id, type),
                          :job => Delayed::Job.find_by_queue("#{@global_reports_id}_#{type}")}
      end

      if Reports.all_created?(params[:id])
        @all_reports = Reports.get_zipped_reports(@global_reports_id, "global")
      else
        @all_reports = false
      end

      respond_to do |format|
        format.js
        format.html
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
      if params[:report_type] == "all"
        path = Reports.all_reports_path params[:id]
        type = "application/zip"
        if params[:id] =~ /global/
          filename = "global.zip"
        else
          @ingest = Reports.find_ingest params[:id]
          filename = "#{@ingest['provider']}.zip"
        end
      else
        path = Reports.report_path params[:id], params[:report_type]
        type = "text/csv"
        filename = params[:report_type]
      end

      if path
        send_file path, :type => type, :filename => filename
        return
      else
        render status: :forbidden, text: "Access denied"
      end
    end

  end
end