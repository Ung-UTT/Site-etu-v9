# encoding: utf-8

class Classified < ActiveRecord::Base
  paginates_per 50
  has_paper_trail
  include Extensions::Searchable
  searchable_attributes :title, :description, :price, :location

  validates_presence_of :title, :description

  belongs_to :user
  has_many :documents, as: :documentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  def to_s
    "#{price}€ : #{title}"
  end
end
