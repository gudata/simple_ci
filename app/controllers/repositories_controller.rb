class RepositoriesController < ApplicationController

  inherit_resources
  before_filter :valid_repository_check, only: [:refresh_commits, :import_commits]

  def refresh_commits
    resource.refresh_all_commits

    redirect_to [resource, :branches], notice: 'done'
  end

  def import_commits
    resource.import_commits
    redirect_to [resource, :branches], notice: 'done'
  end

  protected
  def permitted_params
    params.permit(repository: [:name, :path])
  end

  def valid_repository_check
    unless resource.found?
      render text: "Invalid path #{resource.path}", layout: 'error'
      return
    end
  end
end
