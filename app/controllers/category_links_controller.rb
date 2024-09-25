class CategoryLinksController < ApplicationController
  def new
    form = NewCategoryLinksForm.new
    render locals: { form: }
  end

  def create
    form = NewCategoryLinksForm.new(category_links_params)
    result = form.save

    # Instantiate worker for each link here and render :new
    render :new
  end

  private

  def category_links_params
    params.fetch(:new_category_links_form, {}).permit :urls
  end
end
