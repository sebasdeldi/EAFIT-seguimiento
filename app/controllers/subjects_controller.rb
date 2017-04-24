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
    sw_dev_principles_q = SwDevPrinciplesQuestion.where(subject: @subject).where(student_id: params[:student_id])
    if params[:class_assistance].present? #ensure that a generic calification has been created/updated
      manage_general_questions(general_q)
    end
    if params[:arguments_presentation].present? #ensure that a software dev calification has been created/updated
      manage_sw_dev_principles_questions(sw_dev_principles_q)
    end
  end

  private
    def manage_sw_dev_principles_questions(sw_dev_principles_q)
      if sw_dev_principles_q.length != 0
        sw_dev_principles_q.first.update!(numeric_calification: numeric_calification_average( params[:arguments_presentation], params[:diagram_structure], params[:objective_presentation], params[:case_use_diagrams], params[:secuence_diagrams],params[:problem_solution], params[:class_diagrams] ), 
        arguments_presentation: params[:arguments_presentation],
        diagram_structure: params[:diagram_structure], objective_presentation: params[:objective_presentation], case_use_diagrams: params[:case_use_diagrams],
        secuence_diagrams: params[:secuence_diagrams], problem_solution: params[:problem_solution], class_diagrams: params[:class_diagrams])
      elsif teacher?(current_user) && request.post?
        SwDevPrinciplesQuestion.create!(teacher_id: current_user.id, 
        numeric_calification: numeric_calification_average(params[:arguments_presentation], params[:diagram_structure], params[:objective_presentation], params[:case_use_diagrams], params[:secuence_diagrams],params[:problem_solution], params[:class_diagrams] ) ,
        student_id: params[:student_id], subject: Subject.find(params[:id]), arguments_presentation: params[:arguments_presentation],
        diagram_structure: params[:diagram_structure], objective_presentation: params[:objective_presentation], case_use_diagrams: params[:case_use_diagrams],
        secuence_diagrams: params[:secuence_diagrams], problem_solution: params[:problem_solution], class_diagrams: params[:class_diagrams])
      end
    end

    def manage_general_questions(general_q)
      if general_q.length != 0
        general_q.first.update!(numeric_calification: numeric_calification_average(params[:class_assistance], params[:class_participation], params[:class_orders_following]),
        class_assistance: params[:class_assistance], class_participation: params[:class_participation], class_orders_following: params[:class_orders_following])
      elsif teacher?(current_user) && request.post?
        GeneralQuestion.create!(teacher_id: current_user.id, numeric_calification: numeric_calification_average(params[:class_assistance], params[:class_participation], params[:class_orders_following]) ,
        student_id: params[:student_id], class_assistance: params[:class_assistance], class_participation: params[:class_participation],
        class_orders_following: params[:class_orders_following], subject: Subject.find(params[:id]))
      end
    end

    def numeric_calification_average (string_calification1, string_calification2, string_calification3, string_calification4="i-0", string_calification5="i-0" , string_calification6="i-0", string_calification7="i-0")
      (string_calification1.last.to_i + string_calification2.last.to_i + string_calification3.last.to_i + string_calification4.last.to_i + string_calification5.last.to_i + string_calification6.last.to_i)
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
