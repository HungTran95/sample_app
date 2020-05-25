module ApplicationHelper
  def full_title page_title
    base_title = T18n.t "base_tile"
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end
end
