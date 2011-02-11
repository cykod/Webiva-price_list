class PriceListSection < DomainModel
  belongs_to :price_list_menu
  has_many :price_list_items, :dependent => :delete_all
  has_domain_file :image_1_id
  has_domain_file :image_2_id
  has_domain_file :image_3_id
  
  validates_presence_of :name
  validates_presence_of :price_list_menu_id

  acts_as_list :column => :position, :scope => :price_list_menu_id

  def child_sections; []; end

  def next_position
    self.price_list_menu.price_list_sections.maximum(:position).to_i + 1
  end
  
  def before_create
    self.position ||= self.next_position
  end
end
