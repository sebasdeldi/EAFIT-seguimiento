class DashboardsController < ApplicationController
  before_action :validate_access, only: [:show]
  before_action :validate_index_access, only: [:index]
  def index

    if params[:q]
			@students = User.search_students(params[:q]).reverse
			@teachers = User.search_teachers(params[:q]).reverse
      @subjects = Subject.search_subject(params[:q]).reverse
		else
			@students = User.where(role: "student").reverse
			@teachers = User.where(role: "teacher").reverse
      @subjects = Subject.all.reverse
    end

    @computer_access_chart = User.where(role: "student").group(:computer_access).count
    @technical_education_chart = User.where(role: "student").group(:technical_education).count
    @highschool_type_chart = User.where(role: "student").group(:highschool_type).count
    @scolarship_chart = User.where(role: "student").group(:scolarship).count
  end

  def show
    @user = User.find(params[:id])
    @user_subjects = @user.subjects
  end

  private
    def validate_access
      if !current_user
        redirect_to new_user_session_path
      elsif params[:id].present?
        user = User.find(params[:id])
        match = teacher_of (user)
        if (match.nil? || match.empty?) && (!admin?(current_user))
          redirect_to user_path current_user
        end
      end
    end

    def validate_index_access
      if !current_user 
        redirect_to new_user_session_path
      elsif !admin?(current_user)
        redirect_to user_path current_user
      end
    end
end
