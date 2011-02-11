class PriceListItem < DomainModel
  belongs_to :price_list_section
  belongs_to :price_list_menu
  
  validates_presence_of :name
  validates_presence_of :price_list_section_id
  
  acts_as_list :column => :position, :scope => :price_list_section_id

  def child_sections; []; end

  def next_position
    self.price_list_section.price_list_items.maximum(:position).to_i + 1
  end
  
  def before_create
    self.price_list_menu_id ||= self.price_list_section.price_list_menu_id
    self.position ||= self.next_position
  end
end
