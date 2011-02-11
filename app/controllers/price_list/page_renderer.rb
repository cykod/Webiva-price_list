class PriceList::PageRenderer < ParagraphRenderer

  features '/price_list/page_feature'

  paragraph :view

  def view
    @options = paragraph_options :view
    @price_list = @options.price_list_menu
    render_paragraph :feature => :price_list_page_view
  end
end
