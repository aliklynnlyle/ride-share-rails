class TokensController < ApplicationController

  before_action :authenticate_user!
  layout "administration"

  def index
    @tokens = current_user.organization.tokens
  end

end
