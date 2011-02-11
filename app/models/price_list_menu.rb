class PriceListMenu < DomainModel
  has_many :price_list_sections, :dependent => :destroy
  has_many :price_list_items
  
  validates_presence_of :name
end
