
class PriceList::ManageController < ModuleController
  component_info 'PriceList'
  
  cms_admin_paths 'content'
  
  before_filter :get_price_list, :except => [:menu]
  
  helper :active_tree

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
    @section = @price_list.price_list_sections.find(params[:path][1]) if params[:path][1]
    
    if @price_list.price_list_sections.size == 0
      @price_list.price_list_sections.create :name => 'Default Section'
    end
    
    get_sections

    cms_page_path ['Content'], 'Edit %s' / @price_list.name

    require_js('scriptaculous-sortabletree/sortable_tree.js')
  end
  
  def add_to_tree
    @section = get_section
    @position = params[:position]

    @new_section = @price_list.price_list_sections.create :name => 'New Section'

    case @position
    when 'top'
      @new_section.insert_at(@section.position)
    else
      @new_section.insert_at(@section.position + 1)
    end
    
    get_sections
  end

  def update_tree
    section_tree = params[:section_tree]
    section_id = section_tree.keys[0]
    @section = @price_list.price_list_sections.find section_id
    @parent = @price_list.price_list_sections.find(section_tree[section_id][:left_id]) unless section_tree[section_id][:left_id].blank?

    if @parent
      @section.insert_at(@parent.position + 1)
    else
      @section.move_to_top
    end

    render :nothing => true
  end

  def section
    get_section
    render :partial => 'section'
  end

  def update_section
    return render(:nothing => true) unless request.post? && params[:section]
    @updated = get_section.update_attributes params[:section]
    @section.reload
    render :partial => params[:section][:items].nil? ? 'edit_section_form' : 'items'
  end

  def delete_section
    return render(:nothing => true) unless request.post?
    get_section.destroy
    @deleted = true
    get_sections
    render :action => 'add_to_tree'
  end

  def new_item
    return render(:nothing => true) unless request.post?
    @item = get_section.price_list_items.new params[:item]
    @new_screen = true
    render :partial => 'edit_item_form', :locals => {:item => @item, :item_index => params[:item_index].to_i}
  end

  protected
  
  def get_price_list
    @price_list ||= PriceListMenu.find params[:path][0]
    @base_path = [@price_list.id]
  end
  
  def get_section
    @section ||= @price_list.price_list_sections.find params[:path][1]
  end
  
  def get_sections
    @sections ||= @price_list.price_list_sections
  end
end
