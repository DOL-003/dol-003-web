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

  def page_title
    @title.present? ? "#{@title} • DOL-003.info" : 'DOL-003.info: The GameCube controller modder directory'
  end

  def canonical_link
    url_for only_path: false, protocol: 'https'
  end

end
