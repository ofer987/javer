class MemberSignupController < ApplicationController
  skip_before_action :authenticate, only: [:new, :create]
  
  def new    
    @user = User.new
  end
  
  def create
    @user = User.new(member_params)
    @user.user_type = UserType["member"]
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  private
  
    def member_params
      params.require(:user).permit(:username, :password, :password_confirmation, 
        :first_name, :last_name)
    end
end
