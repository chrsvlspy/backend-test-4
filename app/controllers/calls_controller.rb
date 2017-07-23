# frozen_string_literal: true
class CallsController < ApplicationController
  # Pagination should be used here.
  def index
    @calls = Call.all.order(updated_at: :desc).limit(10)
  end
end