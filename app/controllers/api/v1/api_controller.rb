module Api::V1
  class ApiController < ApplicationController
    before_action :set_current_user

    def index
      render text: "API"
    end

    private

    def current_account_user
      @current_account_user ||=
        AccountUser.new(user: current_user, account: current_account)
    end

    def current_account
      return nil unless current_user
      @current_account ||=
        current_user.accounts.find_by_id(request.headers['X-accountId']) ||
        current_user.accounts.first
    end

    def current_user
      @current_user ||=
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def set_current_user
      Current.user = current_user
      Current.account = current_account
    end
  end
end
