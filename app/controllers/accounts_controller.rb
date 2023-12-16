class AccountsController < ApplicationController
  def show
    account = Account.find(params[:id])
    render json: account
  end

  def create
    account = Account.new(account_params)
    if account.save
      render json: account, status: :created
    else
      render json: account.errors, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(:name)
  end
end
