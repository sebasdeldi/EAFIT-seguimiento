class BatchLoadsController < ApplicationController
  def load_elements
    if request.post?
      if params[:import_users].present?
        User.import(params[:spreadsheet].path)
      elsif params[:import_subject].present?
        Subject.import(params[:spreadsheet].path)
      end
    end
  end
end
