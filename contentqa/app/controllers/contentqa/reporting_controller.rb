require_dependency "contentqa/application_controller"
require "contentqa/reports"

module Contentqa

  class ReportingController < ApplicationController

    def index
      @providers = Reports.find_last_ingests
    end

    def provider
      @ingest = Reports.find_ingest params[:id]
      @report_types = Reports.find_report_types
      @reports = Hash.new
      @report_types.each do |rt|
        @reports[rt] = Reports.report_exists? @ingest['_id'], rt
      end
    end

    def create
#      Reports.delay.create_report(params[:id], params[:report_type])
      Reports.create_report(params[:id], params[:report_type])
      redirect_to :controller => "reporting", :action => "provider", :id => params[:id]
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
