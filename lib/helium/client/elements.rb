module Helium
  class Client
    module Elements
      def elements
        response = get('/element')
        elements_data = JSON.parse(response.body)["data"]

        elements = elements_data.map do |element_data|
          Element.new(client: self, params: element_data)
        end

        return elements
      end

      def element(id)
        response = get("/element/#{id}")
        element_data = JSON.parse(response.body)["data"]

        return Element.new(client: self, params: element_data)
      end

      def update_element(element, name:)
        path = "/element/#{element.id}"

        body = {
          data: {
            attributes: {
              name: name
            },
            id: element.id,
            type: "element"
          }
        }

        response = patch(path, body: body)
        element_data = JSON.parse(response.body)["data"]

        return Element.new(client: self, params: element_data)
      end
    end
  end
end
