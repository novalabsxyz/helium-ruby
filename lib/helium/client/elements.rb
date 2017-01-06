module Helium
  class Client
    module Elements
      def elements
        Element.all(client: self)
      end

      def element(id)
        Element.find(id, client: self)
      end

      def element_device_configuration(element)
        path = "/element/#{element.id}/device-configuration"
        response = get(path)
        dc_data = JSON.parse(response.body)["data"]
        # dc_data is an array, but there will only be one for one
        return  DeviceConfiguration.new(client: self, params: dc_data[0])
      end

      def element_timeseries(element, opts = {})
        path = "/element/#{element.id}/timeseries"

        params = {
          "page[size]"    => opts.fetch(:size, nil),
          "filter[port]"  => opts.fetch(:port, nil),
          "filter[start]" => datetime_to_iso(opts.fetch(:start_time, nil)),
          "filter[end]"   => datetime_to_iso(opts.fetch(:end_time, nil)),
          "agg[type]"     => opts.fetch(:aggtype),
          "agg[size]"     => opts.fetch(:aggsize)
        }.delete_if { |_key, value| value.to_s.empty? }

        paginated_get(path,
          klass:        Helium::DataPoint,
          cursor_klass: Helium::Timeseries,
          params:       params
        )
      end
    end
  end
end
