class PriceListItem < DomainModel
  belongs_to :price_list_section
  belongs_to :price_list_menu
  has_domain_file :image_1_id
  has_domain_file :image_2_id
  has_domain_file :image_3_id
  
  validates_presence_of :name
  validates_presence_of :price_list_section_id
  
  acts_as_list :column => :position, :scope => :price_list_section_id

  attr_accessor :extra_prices_text
  
  serialize :extra_prices
  
  def child_sections; []; end

  def next_position
    self.price_list_section.price_list_items.maximum(:position).to_i + 1
  end
  
  def before_create
    self.price_list_menu_id ||= self.price_list_section.price_list_menu_id
    self.position ||= self.next_position
    self.extra_prices ||= []
  end
  
  def extra_prices_models
    @extra_prices_models ||= self.extra_prices.collect { |p| Price.new(p) }
  end
  
  def extra_prices_list
    self.extra_prices_models.collect { |m| m.to_s }.join("\n")
  end
  
  def extra_prices_list=(str)
    self.extra_prices = str.split("\n").collect do |line|
      price, name = line.split '::'
      price = price.strip if price
      name = name.strip if name
      name = nil if name.blank?
      price = nil if price.blank?
      price ? Price.new(:price => price, :name => name).to_h : nil
    end.compact
  end
  
  class Price < HashModel
    attributes :price => nil, :name => nil
    
    def to_s
      if self.name
        "#{self.price}::#{self.name}"
      elsif self.price
        "#{self.price}"
      else
        ''
      end
    end
  end
end
