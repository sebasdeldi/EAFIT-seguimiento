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

  def student_status(student)
    student_calification = GeneralQuestion.where(student_id: student.id).first.numeric_calification
    if student_calification > 11
      status = "success"
    elsif student_calification < 11 && student_calification > 6
      status = "warning"
    else
      status = "danger"
    end
  end
  helper_method :student_status



end
