class BuildsController  < ApplicationController
  inherit_resources
  belongs_to :repository

  actions :all, :only => [:index, :show]

  def index
    @builds = repository.builds.newest.page(params[:page])
  end

  def show
    show! do

    end
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
