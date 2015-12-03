require 'open3'

class ProcessCommon
  class << self

    def perform(upload)
      case upload.content_type
        when /zip|7z|rar/
          if File.extname(upload.original_filename) == '.xlsx'
            ExcelJob.perform_later(upload)
          else
            UnpackJob.perform_later(upload)
          end
        when *['application/cdfv2-corrupt', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 
               'application/vnd.ms-excel', 'application/vnd.ms-office']
          ExcelJob.perform_later(upload)
        when *['text/plain', 'text/csv', 'text/x-python', 'application/octet-stream']
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

    def normalize_catalog_number(catalog_number)
      catalog_number.to_s.upcase.gsub(/[^А-ЯA-Z0-9]/i, '')
    end

    def cleanup_price(price)
      # Получаем список всех предложений прайса
      while (offer_id = $redis.spop("price:#{price.id}"))
        # Получаем каталожный номер из предложения
        if catalog_number = $redis.hget(offer_id, :catalog_number)
          # Удаляем из сводного списка каталожных номеров предложение
          $redis.srem("catalog_number:#{catalog_number}", offer_id)
        end
        # Удаляем само предложение
        $redis.del(offer_id)
      end
    end

  end
end
