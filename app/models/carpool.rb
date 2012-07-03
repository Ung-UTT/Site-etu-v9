class Carpool < ActiveRecord::Base
  has_paper_trail
  paginates_per 30
  include Extensions::Searchable
  searchable_attributes :description, :departure, :arrival

  attr_accessible :description, :departure, :arrival, :date, :is_driver
  validates_presence_of :description, :departure, :arrival, :date, :user

  default_scope order: 'date DESC'

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy

  delegate :to_s, to: :decorator
end
