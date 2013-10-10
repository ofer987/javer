class MemberViewerController < ApplicationController
  skip_before_action :authenticate, only: [:all]

  def all
    @users = User.member.all
  end
end
