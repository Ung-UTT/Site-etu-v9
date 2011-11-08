class Pool < ActiveRecord::Base
  has_many :questions
  belongs_to :user

  def votes
    self.questions.map(&:votes).flatten.compact
  end
end
