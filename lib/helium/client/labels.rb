module Helium
  class Client
    module Labels
      def labels
        response = get('/label')
        labels_data = JSON.parse(response.body)["data"]

        labels = labels_data.map do |label_data|
          Label.new(client: self, params: label_data)
        end

        return labels
      end

      def label(id)
        response = get("/label/#{id}")
        label_data = JSON.parse(response.body)["data"]

        return Label.new(client: self, params: label_data)
      end
    end
  end
end
