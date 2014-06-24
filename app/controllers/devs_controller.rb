class DevsController < ApplicationController
  def index
    @enabled = enabled?
    @devs = Dev.all.order(:id => :desc)
    @dev = Dev.new
  end

  def create
    Dev.create(dev_params) if enabled?
    redirect_to devs_path
  end

  private

  def dev_params
    params.require(:dev).permit(:name, :description, :url)
  end

  def enabled?
    cache = Dalli::Client.new
    features = cache.fetch('features', 15) do
      response = Net::HTTP.get_response(URI.parse('http://vuln.alttab.org/features'))
      JSON.parse(response.body)
    end
    features['step3']
  end
end
