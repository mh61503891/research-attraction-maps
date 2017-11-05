require 'open-uri'
require 'json'

class RESAS
  class << self

    def attractions
      entries = []
      prefectures.each do |prefecture|
        entry = attraction(prefecture['prefCode'], prefecture['prefName'])
        entries += entry
      end
      return entries
    end

    def attraction(prefCode, prefName)
      Rails.cache.fetch("models/resas/attractions/#{prefCode}", expires_in:24.hours) do
        JSON.parse(RESAS::API.attraction(prefCode)).dig('result', 'data').map{ |attr|
          attr.merge({
            prefCode:prefCode,
            prefName:prefName
          })
        }
      end
    end

    def prefectures
      JSON.parse(RESAS::API.prefectures).dig('result')
    end
  end

  class API
    class << self

      def attraction(prefCode)
        open("https://opendata.resas-portal.go.jp/api/v1/tourism/attractions?prefCode=#{prefCode}", options){ |io|
          io.read
        }
      end

      def prefectures
        open('https://opendata.resas-portal.go.jp/api/v1/prefectures', options){ |io|
          io.read
        }
      end

      def options
        {
          'X-API-KEY' => ENV['RESAS_API_KEY']
        }
      end

    end
  end

end
