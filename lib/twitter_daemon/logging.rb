# -*- coding: utf-8 -*-

module TwitterDaemon
  module Logging
    class << self
      def logger
        @logger ||= Logger.new
      end
    end

    %w(info debug warn error fatal).each do |name|
      define_method(name) do |*args|
        self.class.logger.__send__(name, *args)
      end
    end

    class Logger
      def initialize
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
      end

      def debug(obj)
      end

      def warn(obj)
      end

      def error(obj)
      end

      def fatal(obj)
      end
    end
  end
end
