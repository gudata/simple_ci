class RepositoriesController < ApplicationController

  inherit_resources
  before_filter :valid_repository_check, only: [:refresh_commits, :import_commits]

  def index
    repositories = collection.order("display_order asc")

    @builds_for_repository = {}
    repositories.each do |repository|
      @builds_for_repository[repository] = repository.builds.newest.limit(7)
      # @builds_for_repository[repository] = repository.builds.newest.in_active_branch.limit(7)
    end

  end

  def update
    update! do |success, failure|
      success.html { redirect_to [:repositories], notice: 'done' }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to [:repositories], notice: 'done' }
    end
  end

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
    params.permit(repository: [:name, :path, :image, :retained_image, :display_order, :auto_fetch, :fetch_interval, :last_fetch])
  end

  def valid_repository_check
    unless resource.found?
      render text: "Invalid path #{resource.path}", layout: 'error'
      return
    end
  end
end
