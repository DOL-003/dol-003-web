class ModdersController < ApplicationController

  def index
    # search page idk
  end

  def show
    @modder = Modder.find_by(slug: params[:id]) or not_found
  end

end
