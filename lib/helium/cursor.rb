module Helium
  class Cursor
    include Enumerable

    def initialize(client:, path:, klass:, params: {})
      @client = client
      @path   = path
      @klass  = klass
      @params = params

      @collection = []
      @next_link  = nil
      @is_last    = false
    end

    def each(start = 0)
      return to_enum(:each, start) unless block_given?

      Array(@collection[start..-1]).each do |element|
        yield(element)
      end

      unless last?
        start = [@collection.size, start].max

        fetch_next_page

        each(start, &Proc.new)
      end
    end

    def to_json(*options)
      self.map(&:as_json).to_json(*options)
    end

    private

    def fetch_next_page
      if @next_link
        response = @client.get(url: @next_link)
      else
        response = @client.get(@path, params: @params)
      end

      json_results  = JSON.parse(response.body)
      data          = json_results["data"]
      links         = json_results["links"]

      @next_link    = links["prev"]
      @is_last      = @next_link.nil?
      @collection  += data.map{ |el| @klass.new(client: @client, params: el) }
    end

    def last?
      @is_last
    end
  end
end
