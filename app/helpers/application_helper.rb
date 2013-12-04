module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Stephane's New App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def tag_cloud(tags, classes)
    max = 0
    tags.each do |t|
      if t.count.to_i > max
        max = t.count.to_i
      end 
    end
    tags.each do |tag|
      index = tag.count.to_f / max * (classes.size - 1)
      yield(tag, classes[index.round])
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    # id = new_object.object_id
    fields = f.fields_for(association, new_object) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields btn btn-primary", data: {fields: fields.gsub("\n", "")})
  end

  def render_stars(rating)
    content_tag :div, star_images(rating), :class => 'stars'
  end
  
  def star_images(rating)
    (0...5).map do |position|
      star_image(((rating-position)*2).round)
    end.join.html_safe
  end
  
  def star_image(value)
    image_tag "star-#{star_type(value)}.png", :size => '20x20'
  end
  
  def star_type(value)
    if value <= 0
      'off'
    elsif value == 1
      'half'
    else
      'on'
    end
  end
end