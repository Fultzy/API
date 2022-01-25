class MainController < ApplicationController

  def ping  # PINGPONG
    render :json => { "success" => true }, status: :ok
  end
end
