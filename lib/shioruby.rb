require 'ostruct'

# SHIORI Protocol Parser / Builder
module Shioruby

  # response messages for status codes
  @@response_message = {
    200 => 'OK',
    204 => 'No Content',
    310 => 'Communicate',
    311 => 'Not Enough',
    312 => 'Advice',
    400 => 'Bad Request',
    418 => "I'm a tea pot",
    451 => 'Unavailable For Legal Reasons',
    500 => 'Internal Server Error',
  }

  class << self

    # parse SHIORI/3.x Request
    # @param [String] request_str SHIORI/3.x Request string
    # @return [OpenStruct] SHIORI/3.x Request object
    def parse_request(request_str)
      lines = request_str.each_line.map(&:chomp).reject(&:empty?)
      request_line = lines.shift
      unless request_line_result = request_line.match(/^(.+) SHIORI\/([\d.]+)$/)
        raise ParseError.new("invalid request line")
      end
      request = OpenStruct.new
      request.method = request_line_result[1]
      request.version = request_line_result[2]
      lines.each do |line|
        unless header_result = line.match(/^(.+?): (.*)$/)
          raise ParseError.new("invalid header")
        end
        request[header_result[1]] = header_result[2]
      end
      request
    end

    # build SHIORI/3.x Response
    # @param [OpenStruct] response SHIORI/3.x Response object
    # @return [String] SHIORI/3.x Response string
    def build_response(response)
      message = response.message || @@response_message[response.code]
      response.version
      lines = ["SHIORI/#{response.version} #{response.code} #{message}"]
      response.each_pair.reject {|key, _| ['code', 'message', 'version', :code, :message, :version].include?(key)}.each do |key, value|
        lines << "#{key}: #{value}"
      end
      lines.join("\n") + "\n\n"
    end

  end

  # parse error
  class ParseError < RuntimeError
  end
end

# convenient for SHIORI Request treatment
class String
  # split \\x01 separated Reference* value like "arg1\\x01arg2\\x01arg3" into Array
  # @param [String] separator separator
  # @return [Array<String>] separated strings
  def separated(separator = "\x01")
    self.split(separator)
  end

  # split \\x01, \\x02 separated Reference* value like "arg1-1\\x01arg1-2\\x02arg2-1\\x01arg2-2" into Array of Array
  # @param [String] separator1 1st level separator
  # @param [String] separator2 2nd level separator
  # @return [Array<Array<String>>] separated strings
  def separated2(separator1 = "\x02", separator2 = "\x01")
    self.split(separator1).map {|element| element.split(separator2)}
  end
end

# convenient for SHIORI Response treatment
class Array
  # join \\x01 separated value like "arg1\\x01arg2\\x01arg3" from Array
  # @param [String] separator separator
  # @return [String] combined strings
  def combined(separator = "\x01")
    self.join(separator)
  end

  # join \\x01, \\x02 separated value like "arg1-1\\x01arg1-2\\x02arg2-1\\x01arg2-2" from Array of Array
  # @param [String] separator1 1st level separator
  # @param [String] separator2 2nd level separator
  # @return [String] combined strings
  def combined2(separator1 = "\x02", separator2 = "\x01")
    self.map {|element| element.join(separator2)}.join(separator1)
  end
end
