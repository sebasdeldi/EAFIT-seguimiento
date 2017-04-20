class SubjectsController < ApplicationController
  before_action :validate_subjects_access, only: [:show]
  before_action :validate_subjects_creation_access, only: [:new]


  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
    if @subject.save
      redirect_to root_path
    else
      redirect_back fallback_location: root_path
    end
  end

  def show
    @subject = Subject.find(params[:id])
    if params[:create_membership] == "true"
      create_membership(@subject)
    end
    general_q = GeneralQuestion.where(subject: @subject).where(student_id: params[:student_id])
    if general_q.length != 0
      #Hacer update del campo de usuarios que tiene la nota promedio
      general_q.first.update!(teacher_id: current_user.id, numeric_calification: numeric_calification_average(params[:class_assistance], params[:class_participation], params[:class_orders_following]) ,
      student_id: params[:student_id], class_assistance: params[:class_assistance],
      class_participation: params[:class_participation], class_orders_following: params[:class_orders_following],
      subject: Subject.find(params[:id]))
    elsif teacher?(current_user) && request.post?
      #Hacer update del campo de usuarios que tiene la nota promedio
      GeneralQuestion.create!(teacher_id: current_user.id, numeric_calification: numeric_calification_average(params[:class_assistance], params[:class_participation], params[:class_orders_following]) ,
      student_id: params[:student_id], class_assistance: params[:class_assistance], class_participation: params[:class_participation],
      class_orders_following: params[:class_orders_following], subject: Subject.find(params[:id]))
    end
  end


  private
    def numeric_calification_average (string_calification1, string_calification2, string_calification3)
      (string_calification1.last.to_i + string_calification2.last.to_i + string_calification3.last.to_i)
    end

    def create_membership(subject)
      user = User.where(email: params[:user_email]).first
      unless user == nil
        subject.users << user unless subject.users.include?(user)
      end
      redirect_back fallback_location: root_path
    end

    def subject_params
      params.require(:subject).permit(:name, :code)
    end

    def validate_subjects_creation_access
      if !current_user
        redirect_to root_path
      elsif !(admin?(current_user))
        redirect_to root_path
      end
    end

    def validate_subjects_access
      subject = Subject.find(params[:id])
      if !current_user
        redirect_to root_path
      elsif !(admin?(current_user) || (teacher?(current_user) && subject.users.include?(current_user)))
        redirect_to root_path
      end
    end
end
