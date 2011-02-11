class PriceListMenu < DomainModel
  has_many :price_list_sections, :dependent => :destroy, :order => 'position'
  has_many :price_list_items
  has_domain_file :image_id
  has_domain_file :document_id
  
  validates_presence_of :name
end
