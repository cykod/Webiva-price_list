class InitialSetup < ActiveRecord::Migration
  def self.up
    create_table :price_list_menus, :force => true do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :price_list_sections, :force => true do |t|
      t.string :name
      t.integer :price_list_menu_id
      t.integer :position
      t.text :description
      t.text :description2
      t.string :section_type
      t.timestamps
    end
    
    add_index :price_list_sections, :price_list_menu_id
    
    create_table :price_list_items, :force => true do |t|
      t.string :name
      t.integer :price_list_section_id
      t.integer :price_list_menu_id
      t.integer :position
      t.string :price
      t.text :extra_prices
      t.text :description
      t.text :description2
      t.string :item_type
      t.timestamps
    end
    
    add_index :price_list_items, :price_list_section_id
    add_index :price_list_items, :price_list_menu_id
  end

  def self.down
    drop_table :price_list_menus
    drop_table :price_list_sections
    drop_table :price_list_items
  end
end
