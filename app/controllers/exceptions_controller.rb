class ExceptionsController < ApplicationController

  layout :choose_layout

  def show
    @exception = request.env['action_dispatch.exception']
    @status_code = @exception.try(:status_code) || ActionDispatch::ExceptionWrapper.new(request.env, @exception).status_code

    render view_for_code(@status_code), status: @status_code
  end

  private

  def view_for_code(code)
    supported_error_codes.fetch(code, '500')
  end

  def supported_error_codes
    {
      404 => '404',
      500 => '500'
    }
  end

  def choose_layout
    case @status_code.to_s.first.to_i
    when 4
      'default'
    when 5
      'exception'
    else
      'exception'
    end
  end

end
