
class PriceList::ManageController < ModuleController
  component_info 'PriceList'
  
  cms_admin_paths 'content'

  helper :active_tree

  # need to include 
  include ActiveTable::Controller
  
  def menu
    @price_list = PriceListMenu.find(params[:path][0]) if params[:path][0]
    @price_list ||= PriceListMenu.new
    
    if request.post? && params[:menu]
      if params[:commit]
        if @price_list.update_attributes params[:menu]
          redirect_to :action => 'edit', :path => @price_list.id
        end
      elsif @price_list.id
        redirect_to :action => 'edit', :path => @price_list.id
      else
        redirect_to :controller => '/content'
      end
    end
    
    cms_page_path ['Content'], @price_list.id ? 'Configure %s' / @price_list.name : 'Create a Menu'
  end

  def edit
    @price_list = PriceListMenu.find params[:path][0]
    @section = @price_list.price_list_sections.find(params[:path][1]) if params[:path][1]
    
    if @price_list.price_list_sections.size == 0
      @price_list.price_list_sections.create :name => 'Default Section'
    end
    
    @sections = @price_list.price_list_sections
    
    cms_page_path ['Content'], 'Edit %s' / @price_list.name

    require_js('scriptaculous-sortabletree/sortable_tree.js')
    require_js('jquery/fieldselection/jquery-fieldselection.pack.js')
  end
end
