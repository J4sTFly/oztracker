class ProcessCategoryLinkWorker
  include Sidekiq::Job

  def perform(link_id)
    link = CategoryLink.find(link_id)

    Rails.logger.info("#{link.id} - #{link.url} processing started")

    link.update(being_processed: true)
    link.update(last_processed_at: DateTime.now)

    ProcessCategoryLinksService.new(link).call

    link.update(being_processed: false)

    Rails.logger.info("#{link.id} - #{link.url} processing finished")
  end

  private
end
