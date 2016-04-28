class DestroyJob < ActiveJob::Base
  queue_as :pricer

  def perform(price)
    ProcessCommon.cleanup_price(price)
    price.destroy
  end
end

