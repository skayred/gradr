class InvitesController < ApplicationController
  before_action :admin_only, only: [:index, :new]
  # skip_before_action :require_no_authentication
  skip_before_action :authenticate_user!
  before_action :admin_only, only: [:index, :new]

  def index
    @invites = Invite.all
    @users = User.all
  end

  def new
    @invite = Invite.new
  end

  # def edit
  #   @course = Course.find_by_id(params[:id])

  #   render :new
  # end

  def create
    u_params = user_params

    user = User.new(email: u_params[:email], role: :user, activated: false )
    user.skip_confirmation_notification!
    user.save!(validate: false)
    invite = Invite.create!(invite_key: User.generate_random_string(25), user_id: user.id)

    redirect_to invites_path
  end

  # def update
  #   course = Course.find_by_id(params[:id])
  #   course.attributes = course_params
  #   course.save!

  #   redirect_to courses_path
  # end

  # def destroy
  #   Course.find_by_id(params[:id]).destroy

  #   redirect_to courses_path
  # end

  def user_params
    params.require(:invite).permit(:email)
  end

  # PUT /resource/confirmation
  def update
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        @confirmable.attempt_set_password(params[:user])
        if @confirmable.valid? and @confirmable.password_match?
          do_confirm
        else
          do_show
          @confirmable.errors.clear #so that we wont render :new
        end
      else
        @confirmable.errors.add(:email, :password_already_set)
      end
    end

    if !@confirmable.errors.empty?
      self.resource = @confirmable
      render 'devise/confirmations/new' #Change this if you don't have the views on default path
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        do_show
      else
        do_confirm
      end
    end
    unless @confirmable.errors.empty?
      self.resource = @confirmable
      render 'devise/confirmations/new' #Change this if you don't have the views on default path 
    end
  end
  
  protected

  def with_unconfirmed_confirmable
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    if !@confirmable.new_record?
      @confirmable.only_if_unconfirmed {yield}
    end
  end

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render 'devise/confirmations/show' #Change this if you don't have the views on default path
  end

  def do_confirm
    @confirmable.confirm
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end

  private
 
  def admin_only
    unless current_user.admin?
      flash[:error] = "You must be an admin to access this information"
      redirect_to root_url
    end
  end
end
