class CategoryLinksController < ApplicationController
  def new
    form = NewCategoryLinksForm.new()
    render locals: { form: }
  end

  def create
    form = NewCategoryLinksForm.new(category_links_params)

    result = form.save
    result.each do |link|
      ProcessCategoryLinkWorker.perform_async(link.id)
    end

    render :new, locals: { form: }
  end

  private

  def category_links_params
    params.fetch(:new_category_links_form, {}).permit :urls
  end
end
