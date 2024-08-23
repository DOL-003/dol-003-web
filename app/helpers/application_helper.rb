module ApplicationHelper

  def current_layout
    controller.send :_layout, lookup_context, []
  end

  def current_modder
    return nil unless user_signed_in?

    Modder.find_by(user: current_user)
  end

  def react_component(component, props = {})
    render 'react_component', locals: {
      component:,
      props: props
        .merge({ csrf_token: form_authenticity_token })
        .deep_transform_keys do |key|
          key.to_s.camelize(:lower) 
        end
        .to_json
    }
  end

  def page_title
    site_name = @compendium.present? ? 'The GameCube Controller Compendium' : 'DOL-003.info'
    @title.present? ? "#{@title} • #{site_name}" : 'DOL-003.info: All about GameCube controllers'
  end

  def page_description
    @description || 'DOL-003.info is a repository of GameCube controller information and a directory of controller modders.'
  end

  def canonical_link
    url_for only_path: false, protocol: 'https'
  end

  def service_link(service)
    classes = "service-pill interactive #{service[1][:solid] ? 'solid' : ''}"
    style = "--service-color: #{service[1][:color]}; --service-color-dark: #{service[1][:color_dark] || service[1][:color]}"
    link_to service[1][:name], modders_path(service: service[0]), class: classes, style:
  end

  def flag_enabled?(flag)
    Flag.enabled?(flag, user: current_user, session_id: session.id)
  end

end
