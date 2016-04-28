require 'open3'
require 'csv'


class ProcessCommon
  class << self

    def perform(upload)
      case File.extname(upload.original_filename)
      when *['.zip', '.7z', '.rar']
        UnpackJob.perform_later(upload)
      when *['.xls', '.xlsx', '.xlsm']
        ExcelJob.perform_later(upload)
      else #when *['.txt', '.csv']
        EncodeJob.perform_later(upload)
      end
    end

    def popen3(command)
      Rails.logger.debug "Executing popen3 command '#{command}'"
      Open3.popen3(command) do |i, o, e, t|
        raise command + " " + e.readlines.to_s unless t.value == 0
        yield i, o, e, t if block_given?
      end
    end

    def normalize_brand(brand)
      @brands_synonyms ||= CSV.read("file.csv").
        map(&:reverse).to_h
      @brands_synonyms[brand.upcase] || brand.upcase
    end

    def normalize_catalog_number(catalog_number)
      catalog_number.to_s.upcase.gsub(/[^А-ЯA-Z0-9]/i, '')
    end

    def normalize_cost(cost)
      cost.gsub(/[^\d\.,]/,'').gsub(',','.').to_i
    end

    def cleanup_price(price)
      # Получаем список всех предложений прайса
      while (offer_id = $redis.spop("p:#{price.id}"))
        # Получаем каталожный номер из предложения
        if (catalog_number = $redis.hget(offer_id, :c)).present?
          $redis.srem("c:#{catalog_number}", offer_id)
        end
        # Удаляем само предложение
        $redis.del(offer_id)
      end
    end

  end
end
