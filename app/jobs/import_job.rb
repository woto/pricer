require 'csv'

class ImportJob < ActiveJob::Base
  queue_as :pricer

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

      catalog_number = nil
      if h['c'] && catalog_number_orig = row[h['c']].to_s
        catalog_number = ProcessCommon.normalize_catalog_number(catalog_number_orig)
      elsif price.def_c
        def_c = price.def_c
        catalog_number = ProcessCommon.normalize_catalog_number(def_c)
      end

      cost = nil
      if h['p'] && cost_orig = row[h['p']].to_s
        cost = ProcessCommon.normalize_cost(cost_orig)
      elsif price.def_p
        def_p = price.def_p
        cost = ProcessCommon.normalize_cost(def_p)
      end

      brand = nil
      if h['b'] && brand_orig = row[h['b']].to_s
        brand = ProcessCommon.normalize_brand(brand_orig)
      elsif price.def_b
        def_b = price.def_b
        brand = ProcessCommon.normalize_brand(def_b)
      end

      days = nil
      if h['d'] && days_orig = row[h['d']].to_s 
        days = days_orig
      elsif price.def_d
        def_d = price.def_d
        days = def_d
      end

      offer_id = "p:#{price.id}:l:#{i}"

      $redis.sadd("p:#{price.id}", offer_id)
      if catalog_number.present?
        $redis.sadd("c:#{catalog_number}", offer_id)
      end

      prepared_data = h.clone.transform_values{|v| row[v]}
        .merge({c: catalog_number, b: brand, p: cost, d: days, r: price.id, l: i})
        .flatten

      $redis.hmset(offer_id, *(prepared_data))

    end
    Rails.logger.info Time.now
    price.update!(upload: upload, imported_at: Time.now)
  end
end
