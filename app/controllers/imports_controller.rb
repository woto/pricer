class ImportsController < ApplicationController

  def create

    @upload = Upload.find(params[:id])

    if (id = price_params[:id]).present?
      @price = Price.find(id)
      @price.update(price_params)
    else
      @price = Price.new(price_params)
    end

    if @price.save
      ImportJob.perform_later(@upload, @price)
      redirect_to prices_path
    else
      render 'uploads/preview'
    end
  end

  def price_params
    params['price'].permit!
  end

  #def import
  #  @price_setting_form = PriceSettingForm.new
  #  prepare_result
  #  render 'preview'
  #end

  #def xlsx2csv
  #  tempfile = Tempfile.new('xlsx2csv')
  #  `xlsx2csv #{@upload.price.file.path} > #{tempfile.path}`
  #  Upload.create!(price: File.open(tempfile.path))
  #  redirect_to :back
  #end

  #def recode
  #  tempfile = Tempfile.new('recode')
  #  `LANG=ru_RU.UTF-8 && cat "#{@upload.price.file.path}" | python -mrecoder utf-8 > #{tempfile.path}`
  #  Upload.create!(price: File.open(tempfile.path))
  #  redirect_to :back
  #end

  #def csv_sniffer_import
  #  JSON.parse(@upload.csv_sniffer_result)
  #end

  #def csv_sniffer
  #  delim = CsvSniffer.detect_delimiter(@upload.price.file.path)
  #  is_quote_enclosed = CsvSniffer.is_quote_enclosed?(@upload.price.file.path)
  #  has_header = CsvSniffer.has_header?(@upload.price.file.path)
  #  quote_char = CsvSniffer.get_quote_char(@upload.price.file.path)
  #  @upload.update!(csv_sniffer_result: {delim: delim, is_quote_enclosed: is_quote_enclosed, has_header: has_header, quote_char: quote_char}.to_json)
  #end

end
