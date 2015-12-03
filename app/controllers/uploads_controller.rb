require 'tempfile'
require "csv"

class UploadsController < ApplicationController
  before_action :set_upload, only: [:show, :edit, :update, :destroy, :head, :preview]

  # GET /uploads
  # GET /uploads.json
  def index
    @uploads = Upload.where(upload: nil).reverse
  end

  # GET /uploads/1
  # GET /uploads/1.json
  def show
    @uploads = Upload.find(params[:id]).uploads
    render "index"
  end

  # GET /uploads/new
  def new
    @upload = Upload.new
  end

  # GET /uploads/1/edit
  def edit
  end

  # POST /uploads
  # POST /uploads.json
  def create
    @upload = Upload.new(upload_params)

    respond_to do |format|
      if @upload.save
        ProcessCommon.perform(@upload)
        format.html { redirect_to @upload, notice: 'Upload was successfully created.' }
        format.json { render :show, status: :created, location: @upload }
      else
        format.html { render :new }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uploads/1
  # PATCH/PUT /uploads/1.json
  def update
    respond_to do |format|
      if @upload.update(upload_params)
        format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
        format.json { render :show, status: :ok, location: @upload }
      else
        format.html { render :edit }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.json
  def destroy
    @upload.destroy
    respond_to do |format|
      format.html { redirect_to uploads_url, notice: 'Upload was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def preview
    @price = Price.new
    @prices = Price.all
  end

  def head
    out = ProcessCommon::popen3("head -n 100 #{@upload.price.file.path}") do |i, o, e, t|
      @result = o.readlines
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload
      @upload = Upload.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def upload_params
			params.require(:upload).permit!
    end

end
