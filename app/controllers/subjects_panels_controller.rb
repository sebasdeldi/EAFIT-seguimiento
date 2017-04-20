class SubjectsPanelsController < ApplicationController
  def index
    @subject = Subject.find(params[:id])
    general_q = GeneralQuestion.where(subject: @subject)

    if params[:q]
      search_id = User.where("names ILIKE ? OR last_names ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")

			@general_q = GeneralQuestion.where(student_id: search_id)
    else
      if admin? (current_user)
          @general_q = general_q
      else
        @general_q = general_q.where(student_id: current_user.id).or(general_q.where(teacher_id: current_user.id))
      end
    end
  end
end
