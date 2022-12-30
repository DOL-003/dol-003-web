module ApplicationHelper

  def current_layout
    self.controller.send :_layout, self.lookup_context, []
  end

  def current_modder
    return nil if !user_signed_in?

    Modder.find_by(user: current_user)
  end

  def react_component(component, props = {})
    render 'react_component', locals: {
      component:,
      props: props
        .merge({ csrf_token: form_authenticity_token })
        .deep_transform_keys do |key| key.to_s.camelize(:lower) end
        .to_json
    }
  end

end
