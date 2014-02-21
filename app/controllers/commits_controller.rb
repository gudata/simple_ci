class CommitsController < ApplicationController
  inherit_resources
  belongs_to :repository
  actions :all, :only => [:update, :index, :edit, :destroy]

  def index
    @search = OpenStruct.new(params[:search])

    if params[:branch_id]
      @branch = repository.branches.find(params[:branch_id])
      commits = @branch.commits
    else
      commits = Commit.scoped
    end

    if @search.q
      commits = commits.where("message LIKE (:query) OR (oid LIKE :query)", query: "%#{@search.q}%")
    end

    @commits = commits.includes(:author, :committer, :branch).order("time DESC").page(params[:page]).per(params[:per])
  end


  protected

  def repository
    parent
  end
  helper_method :repository


  def permitted_params
    params.permit(branch: [:build, :image_uid])
  end
end
