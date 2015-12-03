module ApplicationHelper

  def prepare_result
    @result = []
    CSV.foreach(@upload.price.path, {row_sep: "\r\n"}).each_with_index do |row, i|
      break if i > 1000
      @result << row
    end
    @max_columns_in_result = @result.max{|a, b| a.size <=> b.size }.size
  end

end
