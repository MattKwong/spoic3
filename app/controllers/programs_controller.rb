class ProgramsController < ApplicationController
  layout '_ops_layout'
  load_and_authorize_resource

  autocomplete :admin_user, :name, :full => true, :scopes => [:staff]

  #def autocomplete_user_name
  #  @program = Program.find(params[:program_id])
  #  @users = (User.not_admin.search_by_name(params[:term]) - @program.users)
  #  render :json => json_for_autocomplete(@users, :name, nil)
  #end

  #def autocomplete_food_item
  #  @program = Program.find(params[:program_id])
  #  @food_items = FoodItem.all_for_program(@program).search_by_name(params[:term])
  #  render :json => json_for_autocomplete(@food_items, :name, nil)
  #end

 def index
    @title = "Programs"
    program_user = ProgramUser.find_by_user_id(current_admin_user.id)
    if current_admin_user.staff?
      @active_programs = Program.find(program_user.program_id)
    else
      @active_programs = Program.current
    end
  end

  def show
    @title = @program.name
    @menu_actions = []
    unless params[:scope].nil? || params[:scope] == 'All'
      @purchases = Purchases.last(20)
    end
#    @menu_actions << {:name => "Edit", :path => edit_program_path(@program)} if can? :edit, @program
#    @menu_actions << {:name => "New Purchase", :path => new_program_purchase_path(@program)} if can? :crate, @program.purchases.new
  end

  def edit
    @title = "Editing: #{@program.name}"
  end

  def update
    if @program.update_attributes(params[:program])
      flash[:success] = "#{@program.name} updated successfully"
      redirect_to @program
    else
      @title = "Editing: #{@program.name}"
      render :edit
    end
  end

end
