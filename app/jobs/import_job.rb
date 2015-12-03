require 'csv'

class ImportJob < ActiveJob::Base
  queue_as :default

  def perform(upload, price)

    h = {}
    100.times do |i|
      field = price.send("field_#{i}")
      if field.present?
        h[field] = i
      end
    end

    ProcessCommon.cleanup_price(price)

    Rails.logger.info "Word Count: #{upload.wc}"
    Rails.logger.info Time.now
    CSV.foreach(upload.price.path, quote_char: '"', col_sep: ',', :row_sep => "\r\n").each_with_index do |row, i|
      if h['catalog_number']
        catalog_number = ProcessCommon.normalize_catalog_number(row[h['catalog_number']])
      end

      offer_id = "price:#{price.id}:line:#{i}"

      $redis.sadd("price:#{price.id}", offer_id)
      if catalog_number.present?
        $redis.sadd("catalog_number:#{catalog_number}", offer_id)
      end

      prepared_data = h.clone.transform_values{|v| row[v]}
        .merge({price_title: price.title, price_id: price.id, line: i, import_time: Time.now})
        .flatten

      $redis.hmset(offer_id, *(prepared_data))

    end
    Rails.logger.info Time.now
    price.touch(:imported_at)
  end

end
