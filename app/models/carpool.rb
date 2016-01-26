# encoding: utf-8

class Carpool < ActiveRecord::Base
  has_paper_trail
  paginates_per 30
  include Extensions::Searchable
  searchable_attributes :description, :departure, :arrival

  validates_presence_of :description, :departure, :arrival, :date, :user


  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy

  def to_s
    "#{departure} → #{arrival} (#{I18n.l(date, format: :short)})"
  end
end
