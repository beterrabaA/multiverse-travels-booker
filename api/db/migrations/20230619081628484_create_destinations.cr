class CreateDestinations < Jennifer::Migration::Base
  def up
    create_table :destinations do |t|

      t.integer :location_id

      t.reference :travel
    end
  end

  def down
    drop_table :destinations if table_exists? :destinations
  end
end
