class PriceListSection < DomainModel
  belongs_to :price_list_menu
  has_many :price_list_items, :dependent => :delete_all, :order => 'position'
  has_domain_file :image_1_id
  has_domain_file :image_2_id
  has_domain_file :image_3_id
  
  validates_presence_of :name
  validates_presence_of :price_list_menu_id

  attr_protected :price_list_menu_id

  acts_as_list :column => :position, :scope => :price_list_menu_id

  def child_sections; []; end

  def next_position
    self.price_list_menu.price_list_sections.maximum(:position).to_i + 1
  end
  
  def validate
    self.errors.add_to_base('invalid items') if @new_items && @new_items.detect { |i| ! i.valid? }
  end
  
  def before_create
    self.position ||= self.next_position
  end
  
  def items
    @new_items ||= self.price_list_items.to_a
  end

  def items=(values)
    @new_items = values.collect do |idx, attrs|
      item = self.price_list_items.to_a.find { |s| s.id == attrs[:id].to_i } if attrs[:id]
      item ||= self.price_list_items.new
      item.attributes = attrs
      item
    end.sort { |a,b| a.position <=> b.position }
  end
  
  def after_save
    self.price_list_items = @new_items if @new_items
  end
end
