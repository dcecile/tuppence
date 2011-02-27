require 'rest-client'
require 'json'
require 'nokogiri'
require 'ostruct'

# Web scraping source
class Source

  # Store ID, name, and URIs
  def initialize(id, name, human_uri, robot_uri, regional_uri)
    @id = id
    @name = name
    @human_uri = human_uri
    @robot_uri = robot_uri || human_uri
    @regional_uri = regional_uri
  end

  # Unchanging
  attr_reader :id

  # User-visible name
  attr_reader :name

  # URI where humans can find data
  attr_reader :human_uri

  # URI where robots can find data
  attr_reader :robot_uri

  # URI about regional offices
  attr_reader :regional_uri

  # Simple JSON conversion
  def to_json(*args)
    {
      'id' => @id,
      'name' => @name,
      'human_uri' => @human_uri,
      'robot_uri' => @robot_uri
    }.
      to_json *args
  end

  # Use during getting, prepend the ID to any exception
  def identify_error
    begin
      yield
    rescue => ex
      ex.message.insert(0, "#{@id} error: ")
      raise
    end
  end

  # Download the page
  def get_page
    RestClient.get @robot_uri
  end

  # Parse out a percentage (as a float)
  def parse(text)
    text.gsub(/[\s%]/, '').strip.to_f
  end
end

# Scrape from HTML
class HtmlSource < Source

  # Pass in XPath target
  def initialize(data)
    data = OpenStruct.new data
    super data.id, data.name, data.human_uri, data.robot_uri, data.regional_uri
    @target = data.target
  end

  def get
    identify_error do

      # Download
      page = get_page

      # Parse HTML
      doc = Nokogiri::HTML page

      # Run the XPath
      result = doc.xpath @target

      # None, or multiple, matches is an error
      raise ("Couldn't find target" +
            " (got \"#{result}\")") if
        result.count != 1

      # Parse to float
      parse(result[0].content)
    end
  end
end

# Scrape from Javascript
class JavascriptSource < Source

  # Pass in target and check lambdas
  def initialize(data)
    data = OpenStruct.new data
    super data.id, data.name, data.human_uri, data.robot_uri, data.regional_uri
    @target = data.target
    @checks = data.checks
  end

  def get
    identify_error do

      # Download the page
      page = get_page.

        # Convert the first "var" to an open brace and a key
        gsub(/\A\s*var (\S+) =/, '{"\1" : ').

        # Wrap the last "}" with an extra brace
        gsub(/}\s*;?\s*\z/, '}}').

        # Convert each intermediate "var" to a comma and a new key
        gsub(/}\s*;?\s*var (\S+) =/, '}, "\1": ').

        # Use double quotes, not single
        gsub(/'/, '"').

        # Quote bare keys
        gsub(/(\w+) :/, '"\1" : ')

      # Parse from JSON to Ruby hashes and arrays
      doc = JSON.parse page

      # Ensure all checks pass
      raise "Check failed" if
        !@checks.all? { |check| check.call doc }

      # Run the target lambda, and parse the result as a float
      parse(@target.call(doc))
    end
  end
end
