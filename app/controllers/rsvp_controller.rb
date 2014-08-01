class RsvpController < ApplicationController
  def index
  end

  def search
    @attending = params['response']
  end
end
