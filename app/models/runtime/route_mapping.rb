module VCAP::CloudController
  class RouteMapping < Sequel::Model
    many_to_one :app
    many_to_one :route

    export_attributes :app_port

    import_attributes :app_port

  end
end
