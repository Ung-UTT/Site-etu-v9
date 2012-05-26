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
        clues = clues.downcase.to_ascii.split(' ').map do |clue|
          Regexp.escape(clue)
        end

        select do |record|
          string = @searchable_attributes.map do |attribute|
            record.send(attribute)
          end.join(' ').downcase.to_ascii

          clues.all? { |clue| string.include?(clue) }
        end
      end
    end
  end
end

