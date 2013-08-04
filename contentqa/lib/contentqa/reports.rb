require 'couchrest'
require 'fileutils'

module Contentqa

  module Reports

    def self.find_ingest(id)
#      @db = CouchRest.database("http://162.209.12.195:5984/dashboard")
      @dashboard_db = CouchRest.database("http://camp.dpla.berkman.temphost.net:5970/dashboard")
      @dashboard_db.get(id)
    end

    def self.find_report_types
      @dpla_db = CouchRest.database("http://camp.dpla.berkman.temphost.net:5970/dpla")
      @dpla_db.get('_design/qa_reports')['views'].keys.sort
    end

    def self.find_providers
#      @db = CouchRest.database("http://162.209.12.195:5984/dashboard")
      @dashboard_db = CouchRest.database("http://camp.dpla.berkman.temphost.net:5970/dashboard")
      @dashboard_db.view('all_ingestion_docs/by_provider_name',{:include_docs => true})['rows']
    end

    def self.find_last_ingests
      output = []
      last = nil
      sorted = self.find_providers.sort {|x,y| x['key'] == y['key'] ? y['value'] <=> x['value'] : x['key'] <=> y['key'] } 
      sorted.each do |a|
        output << a if a['key'] != last
        last = a['key']
      end
      output
    end

    def self.report_exists? (id, view)
      base_path = "/tmp/camp70/reports"
      path = File.join(base_path, id, view)
      File.stat(path) if File.exists? path 
    end

    def self.report_path (id, view)
      base_path = "/tmp/camp70/reports"
      path = File.expand_path(File.join(base_path, id, view))
      path if path.match Regexp.new('^' + Regexp.escape(base_path)) and self.find_report_types.include? view
    end

    def self.create_report (id, view)
      @dpla_db = CouchRest.database("http://camp.dpla.berkman.temphost.net:5970/dpla")
      path = report_path id, view
      if path 
        view_name = "qa_reports/%{view}" % {:view => view}
        File.open(path, "w") { |f| @dpla_db.view(view_name) { |row| f << row } }
      end
     end
    
  end

end
