class ChangeHstoreToJsonb < ActiveRecord::Migration
  def up
    change_column_default :customers, :router_options, nil
    change_column :customers, :router_options, "JSONB USING CAST(router_options as JSONB)", default: {}

    change_column_default :vehicles, :router_options, nil
    change_column :vehicles, :router_options, "JSONB USING CAST(router_options as JSONB)", default: {}

    change_column_default :routers, :options, nil
    change_column :routers, :options, "JSONB USING CAST(options as JSONB)", default: {}

    Vehicle.without_callback(:save, :before, :update, :validate) do
      Vehicle.all.each { |vehicle|
        next if vehicle.router_options.blank? || vehicle.router_options.empty?
        vehicle = loop_and_assign_typed_values(vehicle)
        vehicle.save!
      }
    end

    Router.without_callback(:save, :before, :update, :validate) do
      Router.all.each { |router|
        next if router.options.blank? || router.options.empty?
        router = loop_and_assign_typed_values(router, :options)
        router.save!
      }
    end

    Customer.without_callback(:save, :before, :update, :validate) do
      Customer.all.each { |customer|
        next if customer.router_options.blank? || customer.router_options.empty?
        customer = loop_and_assign_typed_values(customer)
        customer.save!
      }
    end
  end

  def down
    ActiveRecord::Base.connection.execute '
      CREATE OR REPLACE FUNCTION jsonb_to_hstore(jsonb)
        RETURNS hstore
        IMMUTABLE
        STRICT
        LANGUAGE sql
      AS $func$
        SELECT hstore(array_agg(key), array_agg(value))
        FROM jsonb_each_text($1)
      $func$;'

    change_column_default :customers, :router_options, nil
    change_column :customers, :router_options, "hstore USING jsonb_to_hstore(router_options)", default: {}

    change_column_default :vehicles, :router_options, nil
    change_column :vehicles, :router_options, "hstore USING jsonb_to_hstore(router_options)", default: {}

    change_column_default :routers, :options, nil
    change_column :routers, :options, "JSONB USING jsonb_to_hstore(options)", default: {}
  end

  private

  def loop_and_assign_typed_values(entity, method = :router_options)
    entity.send(method).each do |key, value|
      if (value == 'true' || value == 'false')
        value = (value == 'true') 
      elsif (value.to_f != 0.0)
        value = value.to_f
      else
        value = value
      end
      entity.send(method)[key] = value
    end
    entity
  end
end