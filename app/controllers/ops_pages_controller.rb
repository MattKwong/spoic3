class OpsPagesController < ApplicationController

  layout 'admin_layout'
#  load_and_authorize_resource

  def food
    @page_title = "SSP Food Cost Tracking"
  end

  def construction
    @page_title = "SSP Construction Cost Tracking"
  end

  def staff
    @page_title = "Staff"
  end

  def show
    @page_title = "Programs"
    program_user = ProgramUser.find_by_user_id(current_admin_user.id)
    if current_admin_user.field_staff?
      @active_programs = Program.find(program_user.program_id)
      redirect_to program_path(program_user.program_id)
    else
      @active_programs = Program.current
    end

    if current_admin_user.admin?
      @page_title= "All Sites Cost Tracking - All Programs"

    else
      if current_admin_user.food_admin?
        @page_title = "Food Cost Tracking - All Programs"

      else
        if current_admin_user.construction_admin?
          @title = "Construction Cost Tracking - All Programs"

        else
          if current_admin_user.field_staff?
            if program_user.job.job_type.construction?
              @page_title = "Construction Cost Tracking: #{program_user.program.name}"

            end
            if program_user.job.job_type.cook?
              @title = "Food Cost Tracking: #{program_user.program.name}"

            end
            if program_user.job.job_type.slc?
              @page_title = "Other Program Cost Tracking: #{program_user.program.name}"

            end
            if program_user.job.job_type.sd?
              @page_title = "All Program Cost Tracking: #{program_user.program.name}"

            end
          else
            @page_title = "Unknown User"

          end
        end
      end
    end
  end
  add_breadcrumb "All Sites", @program_path
end