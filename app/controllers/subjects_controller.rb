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
    programming_fundamentals_q = ProgrammingFundamentalsQuestion.where(subject: @subject).where(student_id: params[:student_id])
    if params[:class_assistance].present? #ensure that a generic calification has been created/updated
      manage_general_questions(general_q)
    end
    if params[:arguments_presentation].present? #ensure that a software dev calification has been created/updated
      manage_sw_dev_principles_questions(sw_dev_principles_q)
    end
    if params[:abstraction].present?
      manage_programming_fundamentals_questions(programming_fundamentals_q)
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

    def manage_programming_fundamentals_questions(programming_fundamentals_q)
      if programming_fundamentals_q.length != 0
        programming_fundamentals_q.first.update!(black_box: params[:black_box], pseudocode: params[:pseudocode],
          diagrams: params[:diagrams],modularity: params[:modularity], sequences: params[:sequences], 
          desitions: params[:desitions], loops: params[:loops], functions: params[:functions], data_structures: params[:data_structures],
          abstraction: params[:abstraction], encapsulation: params[:encapsulation], inheritance: params[:inheritance], polymorphism: params[:polymorphism], 
          class_diagrams: params[:class_diagrams], implementation: params[:implementation], testing: params[:testing], 
          numeric_calification: numeric_calification_average(
            params[:black_box], params[:pseudocode], params[:diagrams], params[:modularity], params[:sequences], params[:desitions], params[:loops], params[:functions], 
            params[:data_structures], params[:abstraction], params[:encapsulation], params[:inheritance], params[:polymorphism], params[:class_diagrams],
            params[:implementation], params[:testing]
          ) )
      elsif teacher?(current_user) && request.post?
        ProgrammingFundamentalsQuestion.create!(teacher_id: current_user.id , student_id: params[:student_id], subject: Subject.find(params[:id]),
          black_box: params[:black_box], pseudocode: params[:pseudocode], diagrams: params[:diagrams],modularity: params[:modularity], sequences: params[:sequences], 
          desitions: params[:desitions], loops: params[:loops], functions: params[:functions], data_structures: params[:data_structures],
          abstraction: params[:abstraction], encapsulation: params[:encapsulation], inheritance: params[:inheritance], polymorphism: params[:polymorphism], 
          class_diagrams: params[:class_diagrams], implementation: params[:implementation], testing: params[:testing],
          numeric_calification: numeric_calification_average(
            params[:black_box], params[:pseudocode], params[:diagrams], params[:modularity], params[:sequences], params[:desitions], params[:loops], params[:functions], 
            params[:data_structures], params[:abstraction], params[:encapsulation], params[:inheritance], params[:polymorphism], params[:class_diagrams],
            params[:implementation], params[:testing]
          ) )
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

    def numeric_calification_average (string_calification1, string_calification2, string_calification3, string_calification4="i-0", string_calification5="i-0" , string_calification6="i-0", string_calification7="i-0", string_calification8="i-0", string_calification9="i-0", string_calification10="i-0", string_calification11="i-0", string_calification12="i-0", string_calification13="i-0", string_calification14="i-0", string_calification15="i-0", string_calification16="i-0")
      (string_calification1.last.to_i + string_calification2.last.to_i + string_calification3.last.to_i + string_calification4.last.to_i + string_calification5.last.to_i + string_calification6.last.to_i + string_calification7.last.to_i + string_calification8.last.to_i + string_calification9.last.to_i + string_calification10.last.to_i + string_calification11.last.to_i + string_calification12.last.to_i + string_calification13.last.to_i + string_calification14.last.to_i + string_calification15.last.to_i + string_calification16.last.to_i)
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
