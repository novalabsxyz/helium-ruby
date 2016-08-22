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

      def new_label(name:)
        path = "/label"

        body = {
          data: {
            attributes: {
              name: name
            },
            type: "label"
          }
        }

        response = post(path, body: body)
        label_data = JSON.parse(response.body)["data"]

        return Label.new(client: self, params: label_data)
      end

      def update_label(label, name:)
        path = "/label/#{label.id}"

        body = {
          data: {
            attributes: {
              name: name
            },
            id: label.id,
            type: "label"
          }
        }

        response = patch(path, body: body)
        label_data = JSON.parse(response.body)["data"]

        return Label.new(client: self, params: label_data)
      end

      def delete_label(label)
        path = "/label/#{label.id}"
        delete(path)
      end
    end
  end
end
