module ApplicationHelper

  def current_layout
    self.controller.send :_layout, self.lookup_context, []
  end

end
