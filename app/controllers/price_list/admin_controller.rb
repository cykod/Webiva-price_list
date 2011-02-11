
class PriceList::AdminController < ModuleController

  component_info 'PriceList', :description => 'Price List support', 
                              :access => :public
                              
  # Register a handler feature
  register_permission_category :price_list, "PriceList" ,"Permissions related to Price List"
  
  register_permissions :price_list, [[:manage, 'Manage Price List', 'Manage Price List'],
                                     [:config, 'Configure Price List', 'Configure Price List']
                                    ]
  cms_admin_paths "options",
     "Price List Options" => {:action => 'index'},
     "Options" => { :controller => '/options'},
     "Modules" => { :controller => '/modules'}

  permit 'price_list_config'

  public 
 
end
