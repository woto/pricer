class CleanupJob < ActiveJob::Base
  queue_as :pricer

  def perform(price)
    ProcessCommon.cleanup_price(price)
  end
end
