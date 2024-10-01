class CategoryLinksController < ApplicationController
  def index
    form = SearchCategoryLinksForm.new(search_form_params)

    respond_to do |format|
      format.html { render locals: { form: } }
      format.js do
        prices, products = form.search
        render locals: { form:, prices:, products: }
      end
    end
  end

  def new
    form = NewCategoryLinksForm.new()
    render locals: { form: }
  end

  def create
    form = NewCategoryLinksForm.new(category_links_params)

    result = form.save
    if result
      result.each do |link|
        ProcessCategoryLinkWorker.perform_async(link.id)
      end
    end

    render :new, locals: { form: }
  end

  private

  def search_form_params
    form_params = params.fetch(:search_category_links_form, {}).permit(:pattern)
    form_params.to_h.merge(date_params)
  end

  def date_params
    dates = params.fetch(:search_category_links_form, {}).permit :start_date, :end_date

    return {} unless dates.present?

    start_date = Date.parse("#{dates["start_date(1i)"]}/#{dates["start_date(2i)"]}/#{dates["start_date(3i)"]}")
    end_date = Date.parse("#{dates["end_date(1i)"]}/#{dates["end_date(2i)"]}/#{dates["end_date(3i)"]}")
    { start_date:, end_date: }
  end


  def category_links_params
    params.fetch(:new_category_links_form, {}).permit :urls
  end
end
