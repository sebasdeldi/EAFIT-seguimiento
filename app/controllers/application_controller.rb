class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def admin? (user)
    if (current_user && (user.role == "admin" || user.role == "admin teacher"))
      true
    end
  end
  helper_method :admin?

  def student? (user)
    true if user.role == "student"
  end
  helper_method :student?

  def teacher? (user)
    if user.role == "teacher" || user.role == "admin teacher"
      true
    end
  end
  helper_method :teacher?

  def teacher_of (user)
    match = []
    user.subjects.each do |subject|
      match = subject.users.where(id: current_user.id)
    end
    match
  end
  helper_method :teacher_of

  def student_general_status(student)
    if !GeneralQuestion.where(student_id: student.id).first.nil?
      student_calification = GeneralQuestion.where(student_id: student.id).first.numeric_calification
      if student_calification > 11
        status = "success"
      elsif student_calification < 11 && student_calification > 6
        status = "warning"
      else
        status = "danger"
      end
    else
      ''
    end
  end
  helper_method :student_general_status
  
  def student_sw_dev_status(student)
    if !SwDevPrinciplesQuestion.where(student_id: student.id).first.nil?
      student_calification = SwDevPrinciplesQuestion.where(student_id: student.id).first.numeric_calification
      if student_calification > 24
        status = "success"
      elsif student_calification < 24 && student_calification > 13
        status = "warning"
      else
        status = "danger"
      end
    else
      ''
    end
  end
  helper_method :student_sw_dev_status

  def average_status(student)
    calification_status = [student_general_status(student), student_sw_dev_status(student)]
    success_count = calification_status.count("success")
    warning_count = calification_status.count("warning")
    danger_count = calification_status.count("danger")
    empty_count = calification_status.count('')

    
    if ((success_count == 2) || (success_count == 1 && warning_count == 1) || (success_count == 1 && empty_count == 1))
      status = "success"
    elsif ((warning_count == 2) || (warning_count == 1 && empty_count == 1))
      status =  "warning"
    elsif ((danger_count == 2) || (danger_count == 1 && warning_count == 1) || (success_count == 1 && danger_count == 1) || (danger_count == 1 && empty_count == 1))
      status =  "danger"
    else
      status = ''
    end
  end
  helper_method :average_status

end
