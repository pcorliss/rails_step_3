class DevsController < ApplicationController

  SPAM = %w(
    cialis
    viagra
    levitra
  )

  def index
    @enabled = enabled?
    Dev.where('created_at < ?', 1.hour.ago).destroy_all
    @devs = Dev.all.order(:id => :desc)
    @dev = Dev.new
  end

  def create
    # TODO full blown akismet implemntation
    name = dev_params[:name].downcase
    desc = dev_params[:description].downcase
    SPAM.each do |phrase|
      if name.include?(phrase) || desc.include?(phrase)
        puts "SPAM: #{phrase}, #{name}, #{desc}"
        return redirect_to devs_path
      end
    end
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
