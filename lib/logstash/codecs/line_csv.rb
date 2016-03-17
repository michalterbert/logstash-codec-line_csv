# encoding: utf-8
require "logstash/codecs/base"
require "logstash/util/charset"

# Line-oriented text data.
#
# Only Encoding behavior: Each event will be emitted with a trailing newline.
class LogStash::Codecs::Line_csv < LogStash::Codecs::Base
  config_name "line_csv"

  # Set the desired text format for encoding.
  # Format is ready for CSV data (you can use this codec for WebHDFS CSV output)
  # All doesnt exist variables like %{[val1]} or %{[array1][val2]} from CSV template will be removed at the end
  # Format should be a CSV template with field as variables
  config :format, :validate => :string

  # The character encoding used in this input. Examples include `UTF-8`
  # and `cp1252`
  #
  # This setting is useful if your log files are in `Latin-1` (aka `cp1252`)
  # or in another character set other than `UTF-8`.
  #
  # This only affects "plain" format logs since json is `UTF-8` already.
  config :charset, :validate => ::Encoding.name_list, :default => "UTF-8"

  # Change the delimiter that separates lines
  config :delimiter, :validate => :string, :default => "\n"

  public
  def register
    require "logstash/util/buftok"
    @buffer = FileWatch::BufferedTokenizer.new(@delimiter)
    @converter = LogStash::Util::Charset.new(@charset)
    @converter.logger = @logger
  end

  public
  def flush(&block)
    remainder = @buffer.flush
    if !remainder.empty?
      block.call(LogStash::Event.new("message" => @converter.convert(remainder)))
    end
  end

  public
  def encode(event)
    if event.is_a? LogStash::Event and @format
      s = event.sprintf(@format)
      clean_string = s.gsub( %r{\%[0-9a-zA-Z\-\{\[\_\]]*\}}, '' )
      @on_event.call(event, clean_string + @delimiter)
    else
      @on_event.call(event, event.to_s + @delimiter)
    end
  end # def encode

end # class LogStash::Codecs::Line_csv
