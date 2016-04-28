class SearchController < ApplicationController

  def show
    @search = SearchForm.new(catalog_number: params[:catalog_number])
    
    @results = []
    offers_ids = $redis.smembers("c:#{ProcessCommon.normalize_catalog_number(@search.catalog_number)}")
    offers_ids.each do |offer_id|
      result = $redis.hgetall(offer_id)
      price = Price.find(result['r'].to_i)
      unless price.hide
        result['m'] = price.comment
        result['t'] = price.imported_at
        result['z'] = price.title
        @results << result
      end
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    redirect_to catalog_number_search_path params[:search_form][:catalog_number]
  end

end
