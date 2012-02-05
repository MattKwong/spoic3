class RosterItemController < ApplicationController
#  load_and_authorize_resource
  before_filter :check_for_cancel, :only => [:create, :update]


  def new
    @roster_item = RosterItem.new
    @roster_item.roster_id=params[:roster_id]
    @roster_item.group_id= Roster.find(params[:roster_id]).group_id
    @title = "Add Participant Information"
    @grade_list = ['9th', '10th', '11th', '12th', 'Graduate', 'Adult']
    @size_list = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL']
    @youth_list = [["Youth", true], ["Counselor", false]]
   end

  def create

    @roster_item = RosterItem.new(params[:roster_item])
    @roster_item.state.upcase!
    @liaison_id = ScheduledGroup.find(@roster_item.group_id).liaison_id

    if @roster_item.valid?
      @roster_item.save!
      flash[:notice] = "Successful entry of new participant"
      redirect_to show_roster_path(@roster_item.roster_id)
    else
      @title = "Add Participant Information"
      @grade_list = ['9th', '10th', '11th', '12th', 'Graduate', 'Adult']
      @size_list = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL']
      @youth_list = [["Youth", true], ["Counselor", false]]
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
    @roster_item = RosterItem.find(params[:id])
    @title = "Edit Participant Information"
    @grade_list = ['9th', '10th', '11th', '12th', 'Graduate', 'Adult']
    @size_list = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL']
    @youth_list = [["Youth", true], ["Counselor", false]]
  end

  def update
    @roster_item = RosterItem.find(params[:id])
    @roster_item.update_attributes(params[:roster_item])
    redirect_to show_roster_path(@roster_item.roster_id)
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

