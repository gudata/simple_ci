class BuildsController  < ApplicationController
  inherit_resources
  belongs_to :repository

  actions :all, :only => [:index, :show]

  def index
    @builds = repository.builds.newest

    @builds = @builds.in_branch(params[:branch_id]) if params[:branch_id]

    @builds = @builds.page(params[:page])
  end

  def cancel_all
    canceled = 0
    repository.builds.pending.find_each do |build|
      canceled += build.cancel ? 1 : 0
    end

    flash[:success] = "canceled #{canceled} builds"
    redirect_to action: :index
  end

  def stop
    # check if we really don't run this process in the background
    if resource.fire_state_event :mark_unknown
      flash[:success] = "done"
    else
      flash[:error] = "Can't stop"
    end
    redirect_to action: :index
  end

  def start_new
    resource.fire_state_event :mark_pending

    redirect_to action: :index
  end


  def repository
    parent
  end
  helper_method :repository

end
