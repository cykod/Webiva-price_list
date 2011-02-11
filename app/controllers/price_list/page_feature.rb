class PriceList::PageFeature < ParagraphFeature

  feature :price_list_page_view, :default_feature => <<-FEATURE
    View Feature Code...
  FEATURE

  def price_list_page_view_feature(data)
    webiva_feature(:price_list_page_view,data) do |c|
      # c.define_tag ...
    end
  end

end
