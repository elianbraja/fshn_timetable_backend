class CreatorsController < ApplicationController
  def show
    render json: Creator.first
  end
end
