class UsersController < ApplicationController
  protect_from_forgery with: :null_session
  def register
    name = params[:name]
    password = params[:password]

    if User.exists?(name)
      render json: {
        error: "User exists. Please use another username",
        status: 422
      }, status: 422
      return
    end

    validation_msg = User.validate(name, password)
    if !validation_msg.nil? && validation_msg.length > 0
      render json: {
        error: validation_msg,
        status: 422
      }, status: 422
      return
    end

    resp = User.create_user(name, password)
    if resp != "OK"
      render json: {
        error: "Internal server error: " + resp,
        status: 500
      }, status: 500
      return
    end

    render json: {
      message: "User has been created.",
      status: 200
    }, status: 200
  end

  def login
    name = params[:name]
    password = params[:password]

    if !User.exists?(name)
      render json: {
        error: "User doesn't exist.",
        status: 404
      }, status: 404
      return
    end

    if !User.login?(name, password)
      render json: {
        error: "Password is not correct.",
        status: 401
      }, status: 401
      return
    end

    render json: {
      error: "User login successfully.",
      status: 200
    }, status: 200
  end

  private
  def user_params
    params.require(:user).permit(:name, :password)
  end
end
