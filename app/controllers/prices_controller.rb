class PricesController < ApplicationController
  include ActionController::Live
  before_action :set_price, only: [:show, :edit, :update, :destroy, :list, :cleanup, :download, :cheap]

  # GET /prices
  # GET /prices.json
  def index
    @prices = Price.order(imported_at: :desc)
  end

  # GET /prices/1
  # GET /prices/1.json
  def show
  end

  # GET /prices/new
  def new
    @price = Price.new
  end

  # GET /prices/1/edit
  def edit
  end

  # POST /prices
  # POST /prices.json
  def create
    @price = Price.new(price_params)

    respond_to do |format|
      if @price.save
        format.html { redirect_to @price, notice: 'Price was successfully created.' }
        format.json { render :show, status: :created, location: @price }
      else
        format.html { render :new }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prices/1
  # PATCH/PUT /prices/1.json
  def update
    respond_to do |format|
      if @price.update(price_params)
        format.html { redirect_to @price, notice: 'Price was successfully updated.' }
        format.json { render :show, status: :ok, location: @price }
      else
        format.html { render :edit }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prices/1
  # DELETE /prices/1.json
  def destroy
    DestroyJob.perform_later(@price)
    respond_to do |format|
      format.html { redirect_to prices_url, notice: 'Price was scheduled for destroy.' }
      format.json { head :no_content }
    end
  end
  
  def cleanup
    CleanupJob.perform_later(@price)
    respond_to do |format|
      format.html { redirect_to prices_url, notice: 'Price was scheduled for cleanup.' }
      format.json { head :no_content }
    end
  end

  def list
    @sscan_result = $redis.sscan "p:#{@price.id}", params[:scan]
    @results = []
    @sscan_result.last.each do |offer_id|
      @results << $redis.hgetall(offer_id)
    end
  end

  def cheap
    begin
      stream = response.stream
      stream.write "start<br />\r\n"
      scan = nil
      loop do
        sscan_result = $redis.sscan "p:#{@price.id}", scan, count: 1
        scan = sscan_result.first
        catalog_number = $redis.hget(sscan_result.last.first, :c)
        cost = $redis.hget(sscan_result.last.first, :p).to_i
        price = $redis.hget(sscan_result.last.first, :r)
        line = $redis.hget(sscan_result.last.first, :l) 
        brand = $redis.hget(sscan_result.last.first, :b)
        name = $redis.hget(sscan_result.last.first, :n)
        key = "p:#{price}:l:#{line}"

        offers_ids = $redis.smembers("c:#{catalog_number}")
        offers = []
        offers_ids.each do |offer_id|
          if (offer_id != key)
            offer = $redis.hgetall(offer_id)
            offers << offer if offer['b'] == brand
          end
        end

        unless offers.empty?
          median = offers.map{|k, v| k['p'].to_i}.median

          if median/1.20 > cost && cost > 500 && cost < 12000# && offers.size >= 2
            stream.write "#{catalog_number} (#{brand}), #{cost} руб., #{name}, #{key}<br />\r\n"
          end
        end

        if scan == '0'
          stream.write 'end'
          break 
        end
      end
    rescue IOError => e
      puts 'Connection closed'
    ensure
      stream.close
    end
  end

  def download
    begin
      stream = response.stream
      scan = nil
      stream.write '['
      loop do 
        collector = []
        sscan_result = $redis.sscan "p:#{@price.id}", scan
        scan = sscan_result.first
        sscan_result.last.map do |offer_id|
          collector << Yajl::Encoder.encode($redis.hgetall(offer_id))
        end
        str = collector.join(',')
        stream.write str if str.present?

        if scan == '0'
          break 
        else
          stream.write ','
        end
      end
      stream.write ']'
    rescue IOError => e
      puts 'Connection closed'
    ensure
      stream.close
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_price
      @price = Price.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def price_params
      params.require(:price).permit(:title, :supplier_id, :comment, :notes_invisible, :hide, :def_c, :def_b, :def_n, :def_p, :def_d, :def_q, :def_01, :def_02, :def_03, :def_04, :def_05, :def_06, :def_07, :def_c0, :def_c1, :def_c2, :def_c3, :def_c4, :def_c5, :def_c6, :def_c7, :def_c8, :def_c9, :def_r, :def_l, :def_t, *(100.times.map{|i| "field_#{i}"}))
    end
end
