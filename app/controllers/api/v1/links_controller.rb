class Api::V1::LinksController < ApplicationController

  def update
    @link = Link.find_by_id(params[:id])

    if @link && @link.update_attributes(link_params)
      render json: @link
    else
      render json: @link.errors.full_messages, status: 500
    end
  end

  def create
    @link = current_user.links.new(link_params)

    if @link.save
      render partial: "links/link_card", locals: { link: @link }, layout: false
    else
      render json: @link.errors.full_messages, status: 400
    end
  end

  private

  def link_params
    params.require(:link).permit(:title, :url, :read)
  end
end
