class ScriptsController < ApplicationController
  inherit_resources
  before_action {
    @repository = Repository.find(params[:repository_id])
    @branch = @repository.branches.find(params[:branch_id])
  }

  actions :all

  before_filter :fix_line_endings, only: [:update, :create]

  def index
    @scripts = @branch.scripts
  end

  def new
    new! do
      resource.branch_id = @branch.id unless resource.branch_id
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to url_for([:edit, @repository, @branch, resource]), notice: 'done' }
    end
  end

  protected

  def permitted_params
    params.permit(script: [:name, :body, :branch_id, :timout])
  end

  def fix_line_endings
    return if params[:script][:body].blank?
    body = params[:script][:body]
    params[:script][:body] = body.encode(body.encoding, :universal_newline => true).encode(body.encoding, :newline => :universal)
  end
end