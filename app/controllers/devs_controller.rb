class DevsController < ApplicationController
  def index
    @devs = Dev.all.order(:id => :desc)
    @dev = Dev.new
  end

  def create
    Dev.create(dev_params)
    redirect_to devs_path
  end

  private

  def dev_params
    params.require(:dev).permit(:name, :description, :url)
  end
end
