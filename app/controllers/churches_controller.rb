class ChurchesController < ApplicationController
  def main
    @liaison = Liaison.find(params[:id])
    church = Church.find(@liaison.church_id)
    registrations = Registration.find_all_by_liaison_id(@liaison.id)
    groups = ScheduledGroup.find_all_by_liaison_id(@liaison.id)
    invoices = calculate_invoices(groups)
    notes_and_reminders = Reminder.find_all_by_active(true, :order => 'seq_number')
    checklist = ChecklistItem.find(:all, :order => 'seq_number')
    documents = DownloadableDocument.find_all_by_active(true, :order => 'name')
    @church_information = {:church_info => church, :registration_info => registrations,
      :group_info => groups, :invoice_info => invoices, :notes_and_reminders => notes_and_reminders,
      :checklist => checklist, :documents => documents }
#    logger.debug @church_information[:group_info]
#    logger.debug @church_information[:checklist].size
  end

  def edit
  end

  def delete
  end

  def show
  end

  private
  def calculate_invoices(groups)
    @invoices = "Invoice data goes here"
  end
end
