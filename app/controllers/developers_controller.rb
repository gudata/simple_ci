class DevelopersController < InheritedResources::Base
  def permitted_params
    params.permit(developer: [:password, :can_login])
  end
end
