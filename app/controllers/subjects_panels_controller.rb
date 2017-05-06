class SubjectsPanelsController < ApplicationController
  def index
    @subject = Subject.find(params[:id])
    general_q = GeneralQuestion.where(subject: @subject)
    sw_dev_principles_q = SwDevPrinciplesQuestion.where(subject: @subject)
    programming_fundamentals_q = ProgrammingFundamentalsQuestion.where(subject: @subject)

    if params[:q]
      search_id = User.where("names ILIKE ? OR last_names ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
			@general_q = GeneralQuestion.where(student_id: search_id)
      @sw_dev_principles_q = SwDevPrinciplesQuestion.where(student_id: search_id)
      @programming_fundamentals_q = ProgrammingFundamentalsQuestion.where(student_id: search_id)
    else
      if admin? (current_user)
        @general_q = general_q
        @sw_dev_principles_q = sw_dev_principles_q
        @programming_fundamentals_q = programming_fundamentals_q
      else
        @general_q = general_q.where(student_id: current_user.id).or(general_q.where(teacher_id: current_user.id))
        @sw_dev_principles_q = sw_dev_principles_q.where(student_id: current_user.id).or(sw_dev_principles_q.where(teacher_id: current_user.id))
        @programming_fundamentals_q = programming_fundamentals_q.where(student_id: current_user.id).or(programming_fundamentals_q.where(teacher_id: current_user.id))
      end
    end
  end
end
