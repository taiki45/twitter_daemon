# -*- coding: utf-8 -*-

module TwitterDaemon
  module Logging
    def self.logger
      @logger ||= Logger.new
    end

    %w(info debug warn error fatal).each do |name|
      logging = self
      define_method(name) do |*args|
        logging.logger.__send__(name, *args)
      end
    end

    class Logger
      def initialize
        @logger = ::Logger.new(STDOUT)
        @logger.level = ::Logger::DEBUG if debug?
      end

      def daemon?
        false
      end

      def debug?
        false
      end

      def store
        @store ||= DataStore.new.db.collection('log')
      end

      def info(obj)
        @logger.info(obj)
      end

      def debug(obj)
        @logger.debug(obj)
      end

      def warn(obj)
        @logger.warn(obj)
      end

      def error(obj)
        @logger.error(obj)
      end

      def fatal(obj)
        @logger.fatal(obj)
      end
    end
  end
end
