module TomtomBase

  def add_tomtom_credentials customer
    customer.enable_tomtom = true
    customer.tomtom_account = "tomtom_account"
    customer.tomtom_user = "tomtom_user"
    customer.tomtom_password = "tomtom_password"
    customer.save!
    customer
  end

  def set_route
    @route = routes(:route_one_one)
    @route.update! end: @route.start + 5.hours
    @route.planning.update! date: 10.days.from_now
    @vehicle = @route.vehicle_usage.vehicle
    @vehicle.update! tomtom_id: "1-44063-666F24630"
  end

  def with_stubs names, &block
    begin
      stubs = []
      names.each do |name|
        case name
          when :client_objects_wsdl
            api_url = Mapotempo::Application.config.devices.tomtom.api_url
            url = Addressable::Template.new "#{api_url}/objectsAndPeopleReportingService?wsdl"
            stubs << stub_request(:get, url).to_return(File.read(Rails.root.join("test/web_mocks/tomtom/objectsAndPeopleReportingService.wsdl.xml")))
          when :show_object_report
            api_url = Mapotempo::Application.config.devices.tomtom.api_url
            url = Addressable::Template.new "#{api_url}/objectsAndPeopleReportingService"
            stubs << stub_request(:post, url).with(body: /.*showObjectReport.*/).to_return(File.read(Rails.root.join("test/web_mocks/tomtom/objectsAndPeopleReportingService-showObjectReport.xml")))
          when :show_vehicle_report
            api_url = Mapotempo::Application.config.devices.tomtom.api_url
            url = Addressable::Template.new "#{api_url}/objectsAndPeopleReportingService"
            stubs << stub_request(:post, url).with(body: /.*showVehicleReport.*/).to_return(File.read(Rails.root.join("test/web_mocks/tomtom/objectsAndPeopleReportingService-showVehicleReport.xml")))
          when :orders_service_wsdl
            api_url = Mapotempo::Application.config.devices.tomtom.api_url
            url = Addressable::Template.new "#{api_url}/ordersService?wsdl"
            stubs << stub_request(:get, url).to_return(File.read(Rails.root.join("test/web_mocks/tomtom/ordersService.wsdl.xml")))
          when :send_destination_order
            api_url = Mapotempo::Application.config.devices.tomtom.api_url
            url = Addressable::Template.new "#{api_url}/ordersService"
            stubs << stub_request(:post, url).with(body: /.*sendDestinationOrder.*/).to_return(File.read(Rails.root.join("test/web_mocks/tomtom/ordersService-sendDestinationOrder.xml")))
          when :clear_orders
            api_url = Mapotempo::Application.config.devices.tomtom.api_url
            url = Addressable::Template.new "#{api_url}/ordersService"
            stubs << stub_request(:post, url).with(body: /.*clearOrders.*/).to_return(File.read(Rails.root.join("test/web_mocks/tomtom/ordersService-clearOrders.xml")))
          when :show_order_report
            api_url = Mapotempo::Application.config.devices.tomtom.api_url
            url = Addressable::Template.new "#{api_url}/ordersService"
            stubs << stub_request(:post, url).with(body: /.*showOrderReport.*/).to_return(File.read(Rails.root.join("test/web_mocks/tomtom/ordersService-showOrderReport.xml")))
          when :address_service_wsdl
            api_url = Mapotempo::Application.config.devices.tomtom.api_url
            url = Addressable::Template.new "#{api_url}/addressService?wsdl"
            stubs << stub_request(:get, url).to_return(File.read(Rails.root.join("test/web_mocks/tomtom/addressService.wsdl.xml")))
          when :show_address_report
            api_url = Mapotempo::Application.config.devices.tomtom.api_url
            url = Addressable::Template.new "#{api_url}/addressService"
            stubs << stub_request(:post, url).with(body: /.*showAddressReport.*/).to_return(File.read(Rails.root.join("test/web_mocks/tomtom/addressService-showAddressReport.xml")))
        end
      end
      yield
    ensure
      stubs.each do |name|
        remove_request_stub name
      end
    end
  end

end
