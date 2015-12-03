class SearchController < ApplicationController

  def show
    @search = SearchForm.new(catalog_number: params[:catalog_number])
    
    @results = []
    offer_ids = $redis.smembers("catalog_number:#{ProcessCommon.normalize_catalog_number(@search.catalog_number)}")
    offer_ids.each do |offer_id|
      @results << $redis.hgetall(offer_id)
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
