class Quote < ActiveRecord::Base
  belongs_to :user
  
  def random
    all = Quote.all
    return all[rand(all.size)]
  end
end
