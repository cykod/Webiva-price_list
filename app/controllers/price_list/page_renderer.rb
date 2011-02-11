class PriceList::PageRenderer < ParagraphRenderer

  features '/price_list/page_feature'

  paragraph :view

  def view
    @options = paragraph_options :view

    result = renderer_cache(['PriceListMenu', @options.price_list_menu_id]) do |cache|
      @price_list = @options.price_list_menu
      cache[:title] = @price_list ? @price_list.name : nil
      cache[:output] = price_list_page_view_feature
    end

    set_title result.title
    render_paragraph :text => result.output
  end
end
