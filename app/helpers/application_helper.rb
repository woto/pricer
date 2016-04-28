module ApplicationHelper

  def dynamic_fields
    Price::FIELDS.merge(Price::ADDITIONAL_FIELDS).merge(Price::DEFAULT_FIELDS)
  end

  def editable_fields
    Price::FIELDS.merge(Price::ADDITIONAL_FIELDS)
  end

  def tmp_give_me_a_name(result)
    result.reduce({}) {|memo, (k, v)| memo[dynamic_fields.find{|fk, fv| fv == k}.first] = v; memo}.sort
  end

  def root_upload(upload)
    if upload.upload
      root_upload(upload.upload)
    else
      upload
    end
  end

  def prepare_result
    @result = []
    CSV.foreach(@upload.price.path, {row_sep: "\r\n"}).each_with_index do |row, i|
      break if i > 1000
      @result << row
    end
    @max_columns_in_result = @result.max{|a, b| a.size <=> b.size }.size
  end

end
