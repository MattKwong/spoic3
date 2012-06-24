
require 'csv'

class ReportsController < ApplicationController
  load_and_authorize_resource :liaison, :parent => false

  def church_and_liaison(scope = nil)
    @headers = get_headers_full_report
    @rows = get_rows_full_report

    respond_to do |format|
      format.csv { create_csv("liaisons_and_churches-#{Time.now.strftime("%Y%m%d")}.csv") }
      format.html { @title = 'Liaisons and Churches'}
    end
    end

  def scheduled_liaisons
    @headers = get_headers_scheduled_liaisons
    @rows = get_rows_scheduled_liaisons

    respond_to do |format|
      format.csv { create_csv("scheduled liaisons-#{Time.now.strftime("%Y%m%d")}.csv") }
      format.html { @title = 'Scheduled Liaison'}
    end
  end

  def get_headers_full_report
  # Find all liaisons and associated churches. Will contain duplicate church info if more than one liaison is
  # assigned to a church

      liaisons = Liaison.first
      @headers = []
      liaisons.attributes.each do |k, v|
        @headers << k.camelize
      end
      Church.first.attributes.each do |k, v|
        @headers << k.camelize
      end
      #logger.debug @headers.inspect
      return @headers
  end

  def get_rows_full_report

      @rows = []
      liaisons = Liaison.all
      liaisons.each do |l|
          row = []
          l.attributes.each do |k, v|
            row << trim(v)
          end
          if Church.exists?(l.church_id)
            Church.find(l.church_id).attributes.each do |k, v|
              row << trim(v)
            end
          end
          @rows << row
      end
      #logger.debug @rows
      return @rows
  end

  def get_headers_scheduled_liaisons

      @headers = []
      @headers << "Liaison Name" << "Church" << "Liaison Email"
      #logger.debug @headers.inspect
      return @headers
  end

  def get_rows_scheduled_liaisons

      @rows = []
      liaisons = ScheduledGroup.all
      liaisons.each do |l|
          row = []
          row << l.liaison.name << l.church.name << l.liaison.email1
          @rows << row
      end
      return @rows
   end

private
  def trim(s)
    if s.instance_of?(String)
      s.chomp.strip!
    end
    return s
  end

  def create_csv(filename = nil)
      if request.env['HTTP_USER_AGENT'] =~ /msie/i
        headers['Pragma'] = 'public'
        headers["Content-type"] = "text/plain"
        headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
        headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
        headers['Expires'] = "0"
      else
        headers["Content-Type"] ||= 'text/csv'
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
      end
  end

end
