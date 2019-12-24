require 'rack/oauth2'

module Safie
  ISSUER = 'https://app.safie.link'
  DEFAULT_SCOPE = :use
  VERSION = ::File.read(
    ::File.join(::File.dirname(__FILE__), '../VERSION')
  ).chomp

  def self.logger
    @@logger
  end
  def self.logger=(logger)
    @@logger = logger
  end
  self.logger = Logger.new(STDOUT)
  self.logger.progname = 'Safie'

  @sub_protocols = [
    Rack::OAuth2
  ]
  def self.debugging?
    @@debugging
  end
  def self.debugging=(boolean)
    @sub_protocols.each do |klass|
      klass.debugging = boolean
    end
    @@debugging = boolean
  end
  def self.debug!
    @sub_protocols.each do |klass|
      klass.debug!
    end
    self.debugging = true
  end
  def self.debug(&block)
    sub_protocol_originals = @sub_protocols.inject({}) do |sub_protocol_originals, klass|
      sub_protocol_originals.merge!(klass => klass.debugging?)
    end
    original = self.debugging?
    debug!
    yield
  ensure
    @sub_protocols.each do |klass|
      klass.debugging = sub_protocol_originals[klass]
    end
    self.debugging = original
  end
  self.debugging = false
end

require 'safie/client'
require 'safie/access_token'
