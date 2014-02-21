class BranchesController < ApplicationController
  inherit_resources
  belongs_to :repository

  actions :all, :only => [:update, :index, :edit, :destroy]

  def index
    @branches = repository.branches
  end

  def update
    update! do |success, failure|
      success.html { redirect_to [:edit, repository, resource], notice: 'done' }
    end
  end

  def repository
    parent
  end
  helper_method :repository

  protected

  def permitted_params
    params.permit(branch: [:build, :image_uid])
  end

end
