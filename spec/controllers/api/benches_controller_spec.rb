require 'rails_helper'

RSpec.describe Api::BenchesController, type: :controller do

  describe 'GET #show' do
    let! (:bench) { create(:bench) }
    before(:each) do
      get :show, { id: bench.id, format: :json }
    end

    it { should render_template(:show) }
    it { should respond_with(200) }
  end

  describe 'POST #create' do
    context 'with valid params' do
      before(:each) do
        post :create, bench: {
          description: 'meh',
          lat: 25,
          lng: 25
        },
        format: :json
      end

      it { should render_template(:show) }
      it { should respond_with(200) }

      it 'creates the bench' do
        expect(Bench.exists?).to be true
      end
    end

    context 'with invalid params' do
      before(:each) do
        post :create, bench: { description: 'gross' }, format: :json
      end

      it { should respond_with(422) }
      it 'does not create the bench' do
        expect(Bench.exists?).to be false
      end
    end
  end

  describe 'GET #index' do
    render_views

    let!(:bench_1) { create(:bench)}
    let!(:bench_2) { create(:bench, lat: 50, lng: 250) }
    context 'when there are no bounds or seating ranges' do
      before(:each) do
        get :index, { format: :json }
      end

      it { should respond_with(200) }
      it { should render_template(:index) }
      it 'renders all existing benches' do
        rendered_response = JSON.parse(response.body)
        expect(rendered_response.length).to eq(2)
      end
    end
  end
end
