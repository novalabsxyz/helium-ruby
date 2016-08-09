module Helium
  class Timeseries
    include Enumerable
    extend Forwardable

    def_delegators :@data_points, :size, :length

    attr_accessor :data_points

    def initialize(client:, params:)
      @client = client
      @data_points = params.map { |data_point_params|
        DataPoint.new(client: client, params: data_point_params)
      }
    end

    def each(&block)
      @data_points.each(&block)
    end
  end
end
