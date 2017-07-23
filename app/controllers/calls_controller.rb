# frozen_string_literal: true
class CallsController < ApplicationController
  def index
    @calls = Call.all.order(updated_at: :desc).limit(10)
  end
end