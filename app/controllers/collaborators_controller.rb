class CollaboratorsController < ApplicationController
  before_action :set_wiki


  def new
    @collaborator = Collaborator.new(wiki_id: @wiki.id, user_id: params[:user_id])

    if @collaborator.save
      flash[:notice] = "Collaborator added to this wiki."
      redirect_to request.referrer || wikis_path
    else
      flash.now[:alert] = "Unable to add collaborator."
      redirect_to request.referrer || wikis_path
    end
  end

  def destroy
    @collaborator = Collaborator.find(params[:id])

    if @collaborator.destroy
      flash[:notice] = "Collaborator removed from this wiki."
      redirect_to request.referrer || wikis_path
    else
      flash.now[:alert] = "Unable to remove collaborator from this wiki."
      redirect_to request.referrer || wikis_path
    end
  end

  def set_wiki
    @wiki = Wiki.find(params[:wiki_id])
  end

end 
