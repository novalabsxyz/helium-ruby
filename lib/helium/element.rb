module Helium
  class Element < Resource
    attr_reader :name, :mac, :last_seen, :device_type

    def initialize(opts = {})
      super(opts)

      @name        = @params.dig("attributes", "name")
      @mac         = @params.dig("meta", "mac")
      @last_seen   = @params.dig('meta', 'last-seen')
      @device_type = @params.dig('meta', 'device-type')
    end

    def sensors
      Collection.new(klass: Sensor, client: @client, belongs_to: self)
    end
    
    def self.all_path
      "/element?include=label"
    end
    
    def labels
      Collection.new(klass: Label, client: @client, belongs_to: self)
    end

    def device_configuration
      @client.element_device_configuration(self)
    end

    # @return [DateTime, nil] when the resource was last seen
    def last_seen
      return nil if @last_seen.nil?
      @_last_seen ||= DateTime.parse(@last_seen)
    end

    def timeseries(opts = {})
      size        = opts.fetch(:size, 1000)
      port        = opts.fetch(:port, nil)
      start_time  = opts.fetch(:start_time, nil)
      end_time    = opts.fetch(:end_time, nil)
      aggtype     = opts.fetch(:aggtype, nil)
      aggsize     = opts.fetch(:aggsize, nil)

      @client.element_timeseries(self,
        size:       size,
        port:       port,
        start_time: start_time,
        end_time:   end_time,
        aggtype:    aggtype,
        aggsize:    aggsize
      )
    end

    # TODO can probably generalize this a bit more
    def as_json
      super.merge({
        name: name,
        mac: mac,
        last_seen: last_seen,
        device_type: device_type
      })
    end
    
    def add_labels(labels_to_add = [])
      # There's no first-class support for modifying the labels of a element in
      # the API yet, so we modify each label's relationship to the element. Once
      # this is supported in the API, this can use #add_relationships instead.
      # Same comment applies for the following 3 functions
      labels_to_add = Array(labels_to_add)
      labels_to_add.each do |label|
        label.add_elements(self)
      end
      self
    end

    def replace_labels(labels_to_replace = [])
      # To support replacement, we remove this element from each label, and then
      # add it to the specified set
      labels_to_replace = Array(labels_to_replace)
      labels.each do |label|
        label.remove_elements(self)
      end
      labels_to_replace.each do |label|
        label.add_elements(self)
      end
      self
    end

    def remove_labels(labels_to_remove = [])
      labels_to_remove = Array(labels_to_remove)
      labels_to_remove.each do |label|
        label.remove_elements(self)
      end
      self
    end
  end
end
