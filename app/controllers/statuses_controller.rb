class StatusesController < ApplicationController
  skip_before_action :authenticate

  layout false
  # params
  #   token=branch token
  #   show_branch=1/0
  def show
    @state_behaviour = StateBehaviour.new(params[:token])
    @branch = @state_behaviour.branch
    response.headers.except! 'X-Frame-Options'
  end
end
