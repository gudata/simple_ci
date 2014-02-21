class ScriptsController < ApplicationController
  inherit_resources
  before_action {
    @repository = Repository.find(params[:repository_id])
    @branch = @repository.branches.find(params[:branch_id])
  }

  actions :all

  def index
    @scripts = @branch.scripts
  end

  def update
    update! do |success, failure|
      success.html { redirect_to url_for([:edit, @repository, @branch, resource]), notice: 'done' }
    end
  end

  protected

  def permitted_params
    params.permit(script: [:name, :body])
  end

end