class PriceList::PageFeature < ParagraphFeature

  feature :price_list_page_view, :default_feature => <<-FEATURE
    <cms:menu>
     <h1><cms:name/></h1>
     <cms:sections>
       <cms:section>
       <ul>
         <li><cms:name/></li>
         <li><ul>
         <cms:items>
           <cms:item>
           <cms:display>
           <li><cms:name/> - <cms:price/></li>
           <cms:extra_prices>
             <cms:extra_price>
               <li><cms:price/> <cms:name/></li>
             </cms:extra_price>
           </cms:extra_prices>
           </cms:display>
           </cms:item>
         </cms:items>
         </ul></li>
       </ul>
       </cms:section>
     </cms:sections>
    </cms:menu>
  FEATURE

  def price_list_page_view_feature(data)
    webiva_feature(:price_list_page_view,data) do |c|
      c.expansion_tag('menu') { |t| t.locals.menu = data[:price_list] }
      self.price_list_menu_tags c, data
    end
  end
  
  def price_list_menu_tags(context, data, base='menu')
    context.h_tag("#{base}:name") { |t| t.locals.menu.name }
    context.image_tag("#{base}:image") { |t| t.locals.menu.image }
    # context.link_tag("#{base}:document") { |t| t.locals.menu.document ? t.locals.menu.document.url : nil }

    context.loop_tag("#{base}:section") { |t| t.locals.menu.price_list_sections }
    self.price_list_section_tags context, data, "#{base}:section"
  end
  
  def price_list_section_tags(context, data, base='section')
    context.h_tag("#{base}:name") { |t| t.locals.section.name }
    context.h_tag("#{base}:description") { |t| t.locals.section.description }
    context.h_tag("#{base}:extra_description") { |t| t.locals.section.extra_description }
    context.image_tag("#{base}:image_1") { |t| t.locals.section.image_1 }
    context.image_tag("#{base}:image_2") { |t| t.locals.section.image_2 }
    context.image_tag("#{base}:image_3") { |t| t.locals.section.image_3 }
    
    context.loop_tag("#{base}:item") { |t| t.locals.section.price_list_items }
    self.price_list_item_tags context, data, "#{base}:item"
    
    context.expansion_tag("#{base}:display") do |t|
      types = t.attr['types']
      types = types ? types.split(',').map{ |type| type.strip.downcase } : []
      types.empty? ? t.locals.section.section_type.blank? : types.include?(t.locals.section.section_type.strip.downcase)
    end
  end

  def price_list_item_tags(context, data, base='item')
    context.h_tag("#{base}:name") { |t| t.locals.item.name }
    context.h_tag("#{base}:price") { |t| t.locals.item.price }
    context.h_tag("#{base}:description") { |t| t.locals.item.description }
    context.h_tag("#{base}:extra_description") { |t| t.locals.item.extra_description }
    context.image_tag("#{base}:image_1") { |t| t.locals.item.image_1 }
    context.image_tag("#{base}:image_2") { |t| t.locals.item.image_2 }
    context.image_tag("#{base}:image_3") { |t| t.locals.item.image_3 }

    context.loop_tag("#{base}:extra_price") { |t| t.locals.item.extra_prices_models }
    context.h_tag("#{base}:extra_price:price") { |t| t.locals.extra_price.price }
    context.h_tag("#{base}:extra_price:name") { |t| t.locals.extra_price.name }

    context.expansion_tag("#{base}:display") do |t|
      types = t.attr['types']
      types = types ? types.split(',').map{ |type| type.strip.downcase } : []
      types.empty? ? t.locals.item.item_type.blank? : types.include?(t.locals.item.item_type.strip.downcase)
    end
  end
end
