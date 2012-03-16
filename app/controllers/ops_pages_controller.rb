class OpsPagesController < ApplicationController
#  load_and_authorize_resource
  layout '_ops_layout'

  def food
    @title = "SSP Food Cost Tracking"
  end

  def construction
    @title = "SSP Construction Cost Tracking"
  end

  def staff
    @title = "Staff"
  end

  def show
    program_user = ProgramUser.find_by_user_id(current_admin_user.id)
    if current_admin_user.staff?
      @active_programs = Program.find(program_user.program_id)
    else
      @active_programs = Program.current
    end

    if current_admin_user.admin?
      @title = "All Sites Cost Tracking - All Programs"

    else
      if current_admin_user.food_admin?
        @title = "Food Cost Tracking - All Programs"

      else
        if current_admin_user.construction_admin?
          @title = "Construction Cost Tracking - All Programs"

        else
          if current_admin_user.staff?
            if program_user.job.job_type.construction?
              @title = "Construction Cost Tracking: #{program_user.program.name}"

            end
            if program_user.job.job_type.cook?
              @title = "Food Cost Tracking: #{program_user.program.name}"

            end
            if program_user.job.job_type.slc?
              @title = "Other Program Cost Tracking: #{program_user.program.name}"

            end
            if program_user.job.job_type.sd?
              @title = "All Program Cost Tracking: #{program_user.program.name}"

            end
          else
            @title = "Unknown User"

          end
        end
      end
    end
  end

end