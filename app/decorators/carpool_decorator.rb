# encoding: utf-8

class CarpoolDecorator < ApplicationDecorator
  decorates :carpool
  decorates_association :user

  def description
    h.md carpool.description
  end

  def to_s
    "#{departure} → #{arrival} (#{I18n.l(date, format: :short)})"
  end
end
