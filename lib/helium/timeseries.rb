module Helium
  class Timeseries
    include Enumerable
    extend Forwardable

    def_delegators :@data_points, :size, :length, :last

    attr_accessor :data_points

    def initialize(client:, params: [], links: {})
      @client = client

      @data_points = params.map { |data_point_params|
        DataPoint.new(client: client, params: data_point_params)
      }

      @previous_link = links["prev"]
      @next_link     = links["next"]
    end

    def each(&block)
      @data_points.each(&block)
    end

    def previous
      return false if @previous_link.nil?
      @client.sensor_timeseries_by_link(@previous_link)
    end

    def next
      return false if @next_link.nil?
      @client.sensor_timeseries_by_link(@next_link)
    end
  end
end
