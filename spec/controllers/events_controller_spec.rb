RSpec.describe EventsController, type: :controller do
  describe 'GET #index' do
    let(:events) { create_list :event, rand(2..3) }

    context 'when valid request' do
      before do
        events
        get :index
      end

      it 'returns HTTP 200 OK' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns resource' do
        expect(data.size).to eq(events.count)
      end
    end

    describe 'pagination' do
      let(:events) { create_list :event, 5 }

      before do
        events
        get :index, params: {page: {size: '2', number: '0'}}
      end

      it 'returns paged resources' do
        expect(data.size).to eq 2
      end
    end
  end

  describe 'GET #show' do
    let(:event) { create :event }

    before { get :show, params: {id: event.id} }

    it 'returns HTTP 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns resource' do
      expect(data).to eq event.as_json.symbolize_keys
    end
  end

  describe 'POST #create' do
    let(:attributes) { attributes_for :event }

    context 'with valid parameters' do
      before { post :create, params: {data: attributes} }

      it 'returns HTTP 201 Created' do
        expect(response).to have_http_status(:created)
      end

      it 'returns resource' do
        expect(data).to eq Event.last.as_json.symbolize_keys
      end

      it 'create a resource' do
        expect(Event.count).to be 1
      end
    end

    context 'with invalid parameters' do
      before { post :create, params: {data: attributes.merge(title: '')} }

      it 'returns HTTP 422 Unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors' do
        expect(errors).to include(title: [{error: 'blank'}])
      end

      it 'doesn\'t create a resource' do
        expect(Event.count).to be_zero
      end
    end
  end

  describe 'PUT #update' do
    let(:event) { create :event }
    let(:attributes) { attributes_for :event }

    context 'with valid parameters' do
      before { put :update, params: {id: event.id, data: attributes} }

      it 'returns HTTP 200 Ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns updated resource' do
        expect(data[:id]).to eq(event.id)
      end

      it 'updates resource' do
        event.reload
        expect(data).to eq event.as_json.symbolize_keys
      end
    end

    context 'with invalid parameters' do
      before { put :update, params: {id: event.id, data: attributes.merge(title: '')} }

      it 'returns HTTP 422 Unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors' do
        expect(errors).to include(title: [{error: 'blank'}])
      end

      it 'doesn\'t update a resource' do
        expect(event.reload.title).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:event) { create :event }

    before { delete :destroy, params: {id: event.id} }

    it 'returns HTTP 204 No content' do
      expect(response).to have_http_status(:no_content)
    end

    it 'destroys resource' do
      expect(Event.count).to be_zero
    end
  end
end
