class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, :redirect_unless_admin,  only: [:new, :create]
  skip_before_action :require_no_authentication

  private
    def redirect_unless_admin
      unless !current_user || admin?(current_user)
        flash[:error] = "Only admins can do that"
        redirect_to root_path
      end
    end

    def sign_up(resource_name, resource)
      true
    end
    def sign_up_params
      params.require(:user).permit(:names, :last_names, :email, :password, :password_confirmation, :highschool,
        :highschool_type, :technical_education, :origin_municipality, :living_municipality, :living_neighbourhood,
        :scolarship, :computer_access, :address, :role, :code )
    end

end

