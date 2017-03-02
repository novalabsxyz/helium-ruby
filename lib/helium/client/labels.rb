module Helium
  class Client
    module Labels
      def labels
        Label.all(client: self)
      end

      def label(id)
        Label.find(id, client: self)
      end

      def create_label(attributes)
        Label.create(attributes, client: self)
      end

    end
  end
end
