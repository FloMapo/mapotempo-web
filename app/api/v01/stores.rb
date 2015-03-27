class V01::Stores < Grape::API
  helpers do
    # Never trust parameters from the scary internet, only allow the white list through.
    def store_params
      p = ActionController::Parameters.new(params)
      p = p[:store] if p.key?(:store)
      p.permit(:name, :street, :postalcode, :city, :lat, :lng, :open, :close)
    end
  end

  resource :stores do
    desc 'Fetch customer\'s stores.', {
      nickname: 'getStores'
    }
    get do
      present current_customer.stores.load, with: V01::Entities::Store
    end

    desc 'Fetch store.', {
      nickname: 'getStore'
    }
    get ':id' do
      present current_customer.stores.find(params[:id]), with: V01::Entities::Store
    end

    desc 'Create store.', {
      nickname: 'createStore',
      params: V01::Entities::Store.documentation.except(:id).merge({
        name: { required: true },
        city: { required: true }
      })
    }
    post  do
      store = current_customer.stores.build(store_params)
      current_customer.save!
      present store, with: V01::Entities::Store
    end

    desc 'Update store.', {
      nickname: 'updateStore',
      params: V01::Entities::Store.documentation.except(:id)
    }
    put ':id' do
      store = current_customer.stores.find(params[:id])
      store.assign_attributes(store_params)
      store.save!
      store.customer.save! if store.customer
      present store, with: V01::Entities::Store
    end

    desc 'Delete store.', {
      nickname: 'deleteStore'
    }
    delete ':id' do
      current_customer.stores.find(params[:id]).destroy
    end

    desc 'Geocode store.', {
      nickname: 'geocodeStore',
      params: V01::Entities::Store.documentation.except(:id)
    }
    patch 'geocode' do
      store = Store.new(store_params)
      store.geocode
      present store, with: V01::Entities::Store
    end

    if Mapotempo::Application.config.geocode_complete
      desc 'Auto completion on store.', {
        nickname: 'autocompleteStore',
        params: V01::Entities::Store.documentation.except(:id)
      }
      patch 'geocode_complete' do
        p = store_params
        address_list = Geocode.complete(current_customer.stores[0].lat, current_customer.stores[0].lng, 40000, p[:street], p[:postalcode], p[:city])
        address_list = address_list.collect{ |i| {street: i[0], postalcode: i[1], city: i[2]} }
        address_list
      end
    end
  end
end
