require 'money/errors'
require 'money/currency/loader'

class Money
  class Currency
    class Table
      include Money::Currency::Loader

      def fetch(currency_id)
        table.fetch(currency_id)
      end

      def find_id_by_iso_numeric(num)
        id, _ = table.find { |key, currency| currency[:iso_numeric] == num.to_s }
        id
      end

      def all
        table.keys
      end

      def register(curr)
        key = curr.fetch(:iso_code).downcase.to_sym
        @table[key] = curr
        @stringified_keys = stringify_keys
      end

      def unregister(curr)
        existed = @table.delete(currency_key(curr))
        @stringified_keys = stringify_keys if existed
        existed ? true : false
      end

      def validate_currency(currency_id)
        unless stringified_keys.include?(currency_id.to_s.downcase)
          raise UnknownCurrency, "Unknown currency '#{currency_id}'"
        end
      end

      private

      def stringified_keys
        @stringified_keys ||= stringify_keys
      end

      def currency_key(curr)
        curr.is_a?(Hash) ? curr.fetch(:iso_code).downcase.to_sym : curr.downcase.to_sym
      end

      def stringify_keys
        table.keys.each_with_object(Set.new) { |k, set| set.add(k.to_s.downcase) }
      end

      def table
        @table ||= load_currencies
      end
    end
  end
end
