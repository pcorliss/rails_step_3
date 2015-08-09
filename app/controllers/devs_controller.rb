class DevsController < ApplicationController
  SPAM = ["free", "attention", "hi", "urgently", "instant", "friend", "hidden", "for you", "stop", "off", "offer", "now", "hot", "amazing", "satisfaction", "act now", "apply now", "now only", "as seen", "as seen on tv", "avoid", "be your own boss", "work from home", "home based", "buy", "call now", "cash bonus", "free cash", "double your income", "earn $", "multi level marketing", "earn money", "make money", "get paid weekly", "serious cash", "earn cash", "extra income", "fast cash", "immediate payment", "your delayed payment", "funds management", "free access", "free gift", "free info", "information you requested", "check this out", "free offer", "financial freedom", "medicine", "soft tabs", "cialis", "xanax", "valium", "vicodin", "viagra", "levitra", "herbal", "enlargement", "click here", "open now", "take a look", "read now", "don’t delete", "this is not spam", "collect", "compare", "consolidate", "$$$", "credit", "debt", "get out of debt", "eliminate debt", "lower your mortgage rate", "refinance", "lowest insurance rates", "life insurance", "loans", "dear friend", "discount", "lose weight", "online degree", "online marketing", "online pharmacy", "opportunity", "promised you", "search engine listings", "teen", "winner", "you’re a winner", "your family", "your email won", "please help me", "partnership request", "god bless you", "buy now", "job offer", "limited time", "undisclosed recipient"]

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
