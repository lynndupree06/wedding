module ApplicationHelper
  def active_class(url)
    request.fullpath == url ? "active" : nil
  end
end
