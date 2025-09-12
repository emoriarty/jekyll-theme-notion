Jekyll::Hooks.register :posts, :post_render do |post|
  post.output = wrap_images_in_links(post.output)
end

Jekyll::Hooks.register :pages, :post_render do |page|
  page.output = wrap_images_in_links(page.output)
end

def wrap_images_in_links(content)
  content.gsub(/<img([^>]+)>/) do |match|
    img_tag = match
    attributes = $1

    # Extract src attribute
    src_match = attributes.match(/src\s*=\s*["']([^"']+)["']/)
    return match unless src_match

    src = src_match[1]

    # Skip if already inside a link (rough check)
    return match if content.include?("<a") && content.include?(img_tag) &&
                   content.index("<a") < content.index(img_tag) &&
                   content.index("</a>") > content.index(img_tag)

    "<a href=\"#{src}\" rel=\"noopener\">#{img_tag}</a>"
  end
end
