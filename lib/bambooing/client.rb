require 'net/http'
require 'rack'
require 'json'

module Bambooing
  class Client
    EMTPY_BODY = ''.freeze
    class UnknownResponse < StandardError ; end
    class Redirection < StandardError ; end
    class ClientError < StandardError ; end
    class ServerError < StandardError ; end
    attr_reader :path, :params, :headers, :verb, :adapter

    class << self
      def get(path:, params: {}, headers: {})
        new(path: path, params: params, headers: headers, verb: :get).do
      end
      
      def post(path:, params: {}, headers: {})
        new(path: path, params: params, headers: headers, verb: :post).do
      end
    end

    def initialize(path:, params:, headers:, verb:)
      @path = path
      @params = params
      @headers = headers
      @verb = verb
      @adapter = Net::HTTP.new(uri.host, uri.port)
    end

    def do
      adapter.use_ssl = true
      send(verb)
    end

    private

    def get
      request = Net::HTTP::Get.new(uri, default_headers)
      headers.each { |key, value| request.send(:[]=, key, value) }

      response = adapter.request(request)
      handler(response)
    end

    def post
      request = Net::HTTP::Post.new(uri, default_headers)
      request.body = JSON.dump(params)
      headers.each { |key, value| request.send(:[]=, key, value) }

      response = adapter.request(request)
      handler(response)
    end

    def host
      Bambooing.configuration.host
    end

    def to_query_param
      Rack::Utils.build_query(params)
    end

    def uri
      unless defined?(@uri)
        http_uri = "#{host}#{path}"
        http_uri = http_uri + "?#{to_query_param}" if verb == :get
        @uri = URI(http_uri)
      end
      @uri
    end

    def default_headers
      {
        'Content-type': 'application/json;charset=UTF-8',
        'X-Csrf-Token': Bambooing.configuration.x_csrf_token,
        'Cookie': "PHPSESSID=#{Bambooing.configuration.session_id}"
      }
    end

    def handler(response)
      case response
      when Net::HTTPSuccess
        success_handler(response)
      when Net::HTTPRedirection
        redirection_handler(response)
      when Net::HTTPClientError
        client_error_handler(response)
      when Net::HTTPServerError
        server_error_handler(response)
      end
    end

    def success_handler(response)
      return EMTPY_BODY if verb == :post

      payload = JSON.parse(response.body, symbolize_names: true)

      unknown_handler(response) unless payload[:success]

      payload
    end

    def unknown_handler(response)
      log_warn(response)
      raise UnknownResponse
    end

    def redirection_handler(response)
      log_warn(response)
      raise Redirection
    end

    def client_error_handler(response)
      log_warn(response)
      raise ClientError
    end

    def server_error_handler(response)
      log_warn(response)
      raise ServerError
    end

    def log_warn(response)
      Bambooing.logger.warn("Request to #{uri} responded with status: #{response.code}, headers: #{response.to_hash}, body: #{response.body}")
    end
  end
end
