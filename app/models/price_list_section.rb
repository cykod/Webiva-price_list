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

  cached_content :update => [:price_list_menu]

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
      item_id = attrs.delete :id
      item = self.price_list_items.to_a.find { |s| s.id == item_id.to_i } if item_id
      item ||= self.price_list_items.new
      item.attributes = attrs
      item
    end.sort { |a,b| a.position <=> b.position }
  end
  
  def after_save
    if @new_items
      self.price_list_items.each { |cs| cs.destroy unless @new_items.detect { |ns| cs.id == ns.id } }
      @new_items.each { |ns| ns.save }
    end
  end
end
