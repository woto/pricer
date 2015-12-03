require 'filemagic/ext'
#require 'charlock_holmes'
require 'tempfile'

class Upload < ActiveRecord::Base
	belongs_to :upload
  has_many :uploads
  mount_uploader :price, FileUploader

  enum job_type: [:unpack, :excel, :encode, :format]

  before_save :update_meta

  private

  def update_meta
    if price.present? && price_changed?
      self.content_type = File.content_type(price.file.path)
      self.file_size = price.file.size
      ProcessCommon.popen3("wc < #{price.file.path}") do |i, o, e, t|
        self.wc = o.readlines.join
      end
    end
  end

end
