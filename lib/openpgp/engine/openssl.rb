module OpenPGP
  class Engine
    class OpenSSL < Engine
      def self.load!(reload = false)
        require 'openssl' unless defined?(::OpenSSL) || reload
      end

      def self.install!
        load!
        [Random, Digest].each { |mod| install_extensions! mod }
      end

      module Random #:nodoc:
        def number(bits = 32, options = {})
          ::OpenSSL::BN.rand(bits)
        end

        def prime(bits, options = {})
          ::OpenSSL::BN.generate_prime(bits, options[:safe])
        end

        def bytes(count, &block)
          ::OpenSSL::Random.random_bytes(count)
        end
      end

      module Digest #:nodoc:
        def size
          ::OpenSSL::Digest.new(algorithm.to_s).digest_length
        end

        def hexdigest(data)
          ::OpenSSL::Digest.hexdigest(algorithm.to_s, data).upcase
        end

        def digest(data)
          ::OpenSSL::Digest.digest(algorithm.to_s, data)
        end
      end

      module Cipher #:nodoc:
        # TODO
      end

    end
  end
end
