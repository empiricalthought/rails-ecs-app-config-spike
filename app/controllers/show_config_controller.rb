# frozen_string_literal: true

class ShowConfigController < ApplicationController
  def index
    render json: {:value1 => "value1"}
  end
end
