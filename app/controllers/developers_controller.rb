class DevelopersController < InheritedResources::Base
  def permitted_params
    params.permit(developer: [:password, :password_confirmation, :can_login])
  end
end
