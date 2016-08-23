module Helium
  class Client
    module Elements
      def elements
        Element.all(client: self)
      end

      def element(id)
        Element.find(id, client: self)
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
