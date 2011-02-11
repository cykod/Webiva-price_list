
class PriceList::AdminController < ModuleController
  component_info 'PriceList', :description => 'Price List support', :access => :public
                              
  # Register a handler feature
  register_permission_category :price_list, "PriceList" ,"Permissions related to Price List"
  
  register_permissions :price_list, [[:manage, 'Manage Price List', 'Manage Price List'],
                                     [:config, 'Configure Price List', 'Configure Price List']
                                    ]
  permit 'price_list_config'

  content_action  'Create a new Price List', { :controller => '/price_list/manage', :action => 'menu' }, :permit => 'price_list_config'
  
  content_model :price_lists
  
  def self.get_price_lists_info
    PriceListMenu.find(:all, :order => 'name').collect do |menu| 
      { :name => menu.name,
        :url => { :controller => '/price_list/manage', :action => 'edit', :path => menu.id },
        :permission => :price_list_manage,
        :icon => 'icons/content/shop_icon.png'
      }
    end 
  end
end
