class LinksController < ApplicationController
  before_action :require_login
  before_action :set_links, only: [:index, :create]
  before_action :set_link, only: [:update, :edit]

  def index
    @link = Link.new
  end
  
  def create
		@link = current_user.links.new(link_params)

    if @link.save
      flash[:success] = "Link locked!"
      redirect_to links_path
    else
      flash[:error] = @link.errors.full_messages.join('. ')
      render :index
    end
  end

  def edit
  end

  def update
    @link.update(link_params)

    if @link.save
      flash[:success] = "Link updated!"
      redirect_to links_path
    else
      flash[:error] = @link.errors.full_messages.join('. ')
      render :edit
    end
  end

  private
    def require_login
      unless current_user
        flash[:error] = "You must be logged in to see that!"
        redirect_to login_path
      end
    end

    def link_params
      params.require(:link).permit(:url, :title)
    end

    def set_links
      @links = current_user.links.reload
    end

    def set_link
      @link = current_user.links.find_by_id(params[:id])
    end
end
