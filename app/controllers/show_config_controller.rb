# frozen_string_literal: true

class ShowConfigController < ApplicationController
  def index
    render json: _retrieve_config
  end

  private
  def _retrieve_config
    JSON.parse(Net::HTTP.get(URI("http://localhost:2772/applications/app-config-spike/environments/app-config-spike-testing/configurations/app-config-spike")))
  end
end
