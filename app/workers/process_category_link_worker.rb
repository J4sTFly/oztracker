class ProcessCategoryLinkWorker
  include Sidekiq::Job



  def perform(link)
    link.update(being_processed: true)
    link.update(last_processed_at: DateTime.now)

    process_link(link)
  end

  private

  def process_link(link)
    # Process link here
  end
end
