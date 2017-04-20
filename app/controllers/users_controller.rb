class UsersController < ApplicationController
  before_action :validate_access, only: [:edit]

  def edit
		@user = User.find(params[:id])
  end

	def update
    if user_params[:password].blank?
      update_params = user_params_without_password
    else
      update_params = user_params
    end
		user = User.find(params[:id])
		if user.update!(update_params)
			redirect_to user
		else
			redirect_to root_path
		end
	end
  
	private
    def validate_access
      user = User.find(params[:id])
      if (!admin?(current_user) && user != current_user)
        redirect_to root_path
      end 
    end

		def user_params_without_password
			params.require(:user).permit(:names, :last_names, :email, :highschool,
        :highschool_type, :technical_education, :origin_municipality, :living_municipality, :living_neighbourhood,
        :scolarship, :computer_access, :address, :role, :code)
		end

    def user_params
      params.require(:user).permit(:names, :last_names, :email, :password, :password_confirmation, :highschool,
        :highschool_type, :technical_education, :origin_municipality, :living_municipality, :living_neighbourhood,
        :scolarship, :computer_access, :address, :role, :code)
    end

end
