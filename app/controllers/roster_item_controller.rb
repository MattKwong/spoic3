class RosterItemController < ApplicationController
  load_and_authorize_resource
  before_filter :check_for_cancel, :only => [:create, :update]
  layout 'admin_layout'

  def new
    @page_title = 'Add New Participant Information'
    @roster_item = RosterItem.new
    @roster_item.roster_id=params[:roster_id]
    @roster_item.group_id= params[:group_id]
    @title = "Add Participant Information"
    @grade_list = ['9th', '10th', '11th', '12th', 'Graduate', 'Adult']
    @size_list = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL']
    @youth_list = [["Youth", true], ["Counselor", false]]
    @disclosure_status_list = ['Received', 'Incomplete', 'Not Received']
    @covenant_status_list = ['Received', 'Incomplete', 'Not Received']
    @background_status_list = ['Church Verified', 'Online Verified', 'Not Received']
   end

  def create
    @roster_item = RosterItem.new(params[:roster_item])
    @liaison_id = ScheduledGroup.find(@roster_item.group_id).liaison_id
    if !current_admin_user.admin? || @roster_item.youth
       @roster_item.disclosure_status = @roster_item.covenant_status = @roster_item.background_status = 'Not Received'
    end

    if @roster_item.valid?
      @roster_item.save!
      flash[:notice] = "Successful entry of new participant"
      redirect_to show_roster_path(@roster_item.roster_id)
    else
      @title = @page_title = 'Add New Participant Information'
      @grade_list = ['9th', '10th', '11th', '12th', 'Graduate', 'Adult']
      @size_list = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL']
      @youth_list = [["Youth", true], ["Counselor", false]]
      @disclosure_status_list = ['Not Received', 'Received', 'Incomplete' ]
      @covenant_status_list = ['Not Received', 'Received', 'Incomplete']
      @background_status_list = ['Not Received', 'Church Verified', 'Online Verified']
      flash[:error] = "Errors prevented participant entry from being saved."
      render "roster_item/new"
    end
  end

  def check_for_cancel
    unless params[:cancel].blank?
      roster_item = RosterItem.new(params[:roster_item])
      liaison_id = ScheduledGroup.find(roster_item.group_id).liaison_id
      redirect_to show_roster_path(roster_item.roster_id)
    end
  end

  def edit
    @page_title = 'Edit Participant Information'
    @roster_item = RosterItem.find(params[:id])
    @title = "Edit Participant Information"
    @grade_list = ['9th', '10th', '11th', '12th', 'Graduate', 'Adult']
    @size_list = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL']
    @youth_list = [["Youth", true], ["Counselor", false]]
    @disclosure_status_list = ['Not Received', 'Received', 'Incomplete']
    @covenant_status_list = ['Received', 'Incomplete', 'Not Received']
    @background_status_list = ['Church Verified', 'Online Verified', 'Not Received']
  end

  def update
    @roster_item = RosterItem.find(params[:id])
    if @roster_item.update_attributes(params[:roster_item])
      flash[:notice] = "Roster item has been successfully updated."
      redirect_to show_roster_path(@roster_item.roster_id)
    else
      flash[:error] = "Unexpected problem occurred updating this entry."
      @page_title = 'Edit Participant Information'
      @roster_item = RosterItem.find(params[:id])
      @title = "Edit Participant Information"
      @grade_list = ['9th', '10th', '11th', '12th', 'Graduate', 'Adult']
      @size_list = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL']
      @youth_list = [["Youth", true], ["Counselor", false]]
      @disclosure_status_list = ['Not Received', 'Received', 'Incomplete']
      @covenant_status_list = ['Received', 'Incomplete', 'Not Received']
      @background_status_list = ['Church Verified', 'Online Verified', 'Not Received']
      render "roster_item/edit"
    end
  end

  def delete
    @roster_item = RosterItem.find(params[:id])
    @liaison_id = ScheduledGroup.find(@roster_item.group_id).liaison_id

    if @roster_item.delete
      redirect_to show_roster_path(@roster_item.roster_id)
    else
      flash[:notice] = "Unexpected problem occurred deleting this entry"
    end
  end
end

