module ApplicationHelper
  def assign_view_specific_stylesheets(*files)
    content_for(:view_specific_stylesheets) { stylesheet_link_tag(*files) }
  end

  def assign_view_specific_javascripts(*files)
    content_for(:view_specific_javascripts) { javascript_include_tag(*files) }
  end
end
