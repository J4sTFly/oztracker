require 'rails_helper'

RSpec.describe CategoryLinksController, type: :controller do
  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'responds with a 200 status code' do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'responds with a 200 status code' do
      get :new
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { urls: "https://oz.by/books/topic1602.html" } }

    it 'creates a new CategoryLink' do
      expect {
        post :create, params: { new_category_links_form: valid_attributes }
      }.to change(CategoryLink, :count).by(1)
    end

    it 'renders the new template' do
      post :create, params: { new_category_links_form: valid_attributes }
      expect(response).to render_template(:new)
    end
  end
end
