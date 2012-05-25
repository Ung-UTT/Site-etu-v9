module Extensions
  module Searchable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def searchable_attributes *attributes
        @searchable_attributes = *attributes
      end

      def search clues
        clues = clues.downcase.to_ascii.split(' ').map{ |clue| Regexp.escape(clue) }
        select do |record|
          string = @searchable_attributes.map { |attr| record.send(attr) }.join(' ')
          clues.all? do |clue|
            string.downcase.to_ascii.include?(clue)
          end
        end
      end
    end
  end
end

