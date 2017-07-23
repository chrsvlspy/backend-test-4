Rails.application.routes.draw do
  resources :calls, only: [:index]

  namespace :twilio do
    resource :webhooks, only: [], defaults: { format: %i(xml) } do
      collection do
        get 'connect_to_agent_request'
        get 'connect_to_agent'
        get 'record_voicemail'
        get 'call_status'
      end
    end
  end
end
