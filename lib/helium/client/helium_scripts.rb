require 'base64'

module Helium
  class Client
    module HeliumScripts

      def create_script(name, file_content)
        contents = Base64.strict_encode64(file_content)
        Script.create({ name: name , contents: contents }, client: self)
      end

      def scripts
        Script.all(client: self)
      end

      def script(id)
        Script.find(id, client: self)
      end

      def create_library(name, file_content)
        contents = Base64.strict_encode64(file_content)
        Library.create({ name: name , contents: contents }, client: self)
      end

      def libraries
        Library.all(client: self)
      end

      def library(id)
        Library.find(id, client: self)
      end

      def packages
        Package.all(client: self)
      end

      def package(id)
        Package.find(id, client: self)
      end

      def create_package(script, libraries = [], name = nil)
        library_rels = Array(libraries).map do |lib|
          { id: lib.id, type: 'library' }
        end
        body = {
          data: {
            attributes: {
              name: name
            },
            type: 'package',
            relationships: {
              script: {
                data: {
                  id: script.id,
                  type: 'script'
                }
              },
              library: {
                data: library_rels
              }
            }
          }
        }

        response = post('/package', body: body)
        resource_data = JSON.parse(response.body)["data"]
        Package.new(client: self, params: resource_data)
      end

      def sensor_packages
        SensorPackage.all(client: self)
      end

      def sensor_package(id)
        SensorPackage.find(id, client: self)
      end

      def create_sensor_package(sensor, package)
        body = {
          data: {
            type: 'sensor-package',
            relationships: {
              package: {
                data: {
                  id: package.id,
                  type: 'package'
                }
              },
              sensor: {
                data: {
                  id: sensor.id,
                  type: 'sensor'
                }
              }
            }
          }
        }

        response = post('/sensor-package', body: body)
        resource_data = JSON.parse(response.body)["data"]
        SensorPackage.new(client: self, params: resource_data)
      end
    end
  end
end
