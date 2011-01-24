$:.unshift File.expand_path('../',  __FILE__)

require 'rubygems'
require 'sinatra/base'
require 'sinatra/reloader'
require 'rest-client'
require 'json'
require 'date'
require 'haml'
require 'sass'
require 'ostruct'

require 'institutions'
require 'benchmarks'
require 'couch'

AllSources = Institutions + Benchmarks

# Add alias for pretty JSON output
class Object
  def to_pretty_json
    JSON.pretty_generate self
  end
end

# Add method to help with extending structs
class OpenStruct
  def to_h
    @table
  end
end

# Add method for heirarchical sorting
module Enumerable
  def sort_multiple

    # For each pairing, run the caller's block
    sort do |x, y|

      # Expect a list of ones, zeroes, and minus ones
      arr = yield x, y

      # Pick the first non-zero (ie. non-tie)
      arr.detect { |c| c != 0 } ||

        # If none are found, the result for this pair is a tie
        0
    end
  end
end

# Main Sinatra application
class App < Sinatra::Base

  # Set up reloading during development
  configure :development do
    register Sinatra::Reloader
    also_reload "*.rb"
  end

  # Set paths
  set :views, File.expand_path('../', __FILE__)

  # Set up Haml
  set :haml, :format => :html5

  # Main page
  get '/' do

    # Suffixes for making English ordinals
    Suffixes = {
      0 => 'th',
      1 => 'st',
      2 => 'nd',
      3 => 'rd',
      4 => 'th',
      5 => 'th',
      6 => 'th',
      7 => 'th',
      8 => 'th',
      9 => 'th',
    }

    # Get the current data
    data = Couch.get

    # Initialize variables used for rank ties
    previous_rank = 0
    previous_rate = nil

    # Determine the rankings for each institution
    @rankings = Institutions.

      # Keep user info and get the latest rate (last in the array)
      map do |i|
        OpenStruct.new(
          :name => i.name,
          :human_uri => i.human_uri,
          :regional_uri => i.regional_uri,
          :rate => data[i.id][-1]['rate'])
      end.

      # Sort by rate, then by name
      sort_multiple do |r1, r2| [
        r2.rate <=> r1.rate,
        r1.name <=> r2.name]
      end.

      # Simply list 1-N
      each_with_index.

      # Do real rankings with ties accounted for
      map do |r, n|
        if r.rate != previous_rate
          previous_rank += 1
          previous_rate = r.rate
        end
        [r, previous_rank]
      end.

      # Store the rank number and suffix
      map do |r, n|
        OpenStruct.new r.to_h.merge(
          :rank_number => n,
          :rank_suffix => Suffixes[n % 10])
      end

    # Read in styelsheets
    @reset = File.read File.expand_path('../reset.css', __FILE__)
    @style = sass :style

    # Generate the HTML
    haml :index
  end

  # Retrieve raw data as JSON
  get '/data' do
    [
      200,
      { 'Content-Type' => 'application/json' },
      Couch.get.to_pretty_json
    ]
  end

  # Retrieve info about each source, as JSON
  get '/config' do
    [
      200,
      { 'Content-Type' => 'application/json' },
      AllSources.to_pretty_json
    ]
  end

  # Pull current info from all sources
  get '/current' do
    [
      200,
      { 'Content-Type' => 'application/json' },
      AllSources.map { |b|
        {
          'id' => b.id,
          'data' => b.get
        }
      }.
        to_pretty_json
    ]
  end

  # Pull current info from all sources, and save to DB
  def self.fetch

    # Get all previous data
    data = Couch.get

    # Keep track of whether any changes are made
    changed = false

    AllSources.each do |source|

      # Check for newly added sources
      data[source.id] = [] if !data.key? source.id

      # Retrieve the data (log in case of errors)
      puts "Fetching #{source.id}"
      new_rate = source.get
      puts "Got #{new_rate}"

      # Only add a new entry if the data changes
      entries = data[source.id]
      if entries.empty? || entries[-1]['rate'] != new_rate

        # Store today's date, along with the new rate
        entries<<
        {
          'date' => Date.today,
          'rate' => source.get
        }
        
        # Data needs to be saved now
        puts "Added entry"
        changed = true
      end
    end

    # Only save to the DB if an entry has been added
    puts "Put #{Couch.put data}" if changed
  end
end
