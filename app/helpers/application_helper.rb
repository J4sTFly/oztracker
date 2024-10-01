module ApplicationHelper
  def new_link_disabled?
    %w[new create].include? params[:action]
  end

  def format_date(date, years = false)
    years ? date.strftime("%Y.%m.%d") : date.strftime("%m.%d")
  end

  def price_column(prices)
    return "-" unless prices.present?

    prices.map { |p| p.price * (1 - p.discount.to_i) }.sum / prices.count
  end
end
