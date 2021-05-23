class Stock < ApplicationRecord
    has_many :user_stocks
    has_many :users, through: :user_stocks

    @@API_KEY = ENV["IEX_CLOUD_API_KEY"]

    def self.new_from_lookup(ticker_symbol)
        begin
            StockQuote::Stock.new(api_key: @@API_KEY)
            looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
            logger.info looked_up_stock.inspect

            # price = stip_commas(looked_up_stock.latest_price)
            price = looked_up_stock.close

            result = new(
                name: looked_up_stock.company_name,
                ticker: looked_up_stock.symbol,
                last_price: price)

            # logger.info "RESULT................."
            # logger.info result.inspect

            return result

        rescue Exception => e
            return nil
        end
    end

    def self.stip_commas(number)
        number.gsub(",", "")
    end

end
