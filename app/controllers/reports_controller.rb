require 'csv'

class ReportsController < ApplicationController

  def church_and_liaison(scope = nil)
  # Find all liaisons and associated churches. Will contain duplicate church info if more than one liaison is
  # assigned to a church
    begin
      logger.debug request.fullpath
      report_file = setup_csv("liaisons_and_churches-#{Time.now.strftime("%Y%m%d")}")
      liaisons = Liaison.all
      CSV.open(report_file, 'w') do |csv|
        header = []
        liaisons.first.attributes.each do |k, v|
          header << k.camelize
        end
        Church.first.attributes.each do |k, v|
          header << k.camelize
        end
        csv << header
        liaisons.each do |l|
          row = []
          l.attributes.each do |k, v|
            row << v
          end
          if Church.exists?(l.church_id)
            Church.find(l.church_id).attributes.each do |k, v|
              row << v
            end
          end
          csv << row
        end
      end
    flash[:notice] = "#{report_file} has been successfully created."
    rescue => e
      flash[:notice] = "#{report_file} could not be created. Check if a file by that name is open."
    end
    redirect_to root_path
  end

private

  def setup_csv(name = nil)
      name ||= params[:action]
      name += '.csv'
      dir = "\\documents\\"
      path = ENV['USERPROFILE']
      filename = path + dir + name
    logger.debug "File name is: #{filename}"
    begin
      if File.exists?(filename)
        File.delete(filename)
      end
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
      rescue => e
      logger.debug filename
        flash[:notice] = "#{filename} could not be created. Check if a file by that name is open."
    end
    return filename
  end
end
