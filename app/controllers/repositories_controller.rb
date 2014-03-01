class RepositoriesController < ApplicationController

  inherit_resources

  def index
    @repositories = collection.order("display_order asc")

    @builds_for_repository = {}
    @repositories.each do |repository|
      @builds_for_repository[repository] = repository.builds.newest.limit(7) # in_active_branch
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

  protected
  def permitted_params
    params.permit(repository: [:name, :path, :image, :retained_image, :display_order, :auto_fetch, :fetch_interval, :last_fetch])
  end

end
