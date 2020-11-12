module Admin
  class UsersController < ApplicationController
    load_and_authorize_resource :user

    # GET /users
    # GET /users.json
    def index
      @users = User.order(:created_at)
        .search(params[:search])
      @users = @users.where(role: params[:role]) if params[:role].present?

      respond_to do |format|
        format.html do
          @users = @users.page(params[:page])
        end
        format.json do
          @users = @users.where(role: :store_owner).limit(25)
        end
      end
    end

    # GET /users/1
    # GET /users/1.json
    def show
      @created_stores = @user.created_stores.search(params[:search])
      @created_stores = @created_stores.by_state(params[:state]) if params[:state].present?
      @created_stores = @created_stores.by_type(params[:type]) if params[:type].present?
      @created_stores = @created_stores.order(:name).page(params[:page])
    end

    # GET /users/new
    def new
      @user = User.new
    end

    # GET /users/1/edit
    def edit; end

    # POST /users
    # POST /users.json
    def create
      @user = User.new(user_params)
      @user.skip_confirmation!

      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /users/1
    # PATCH/PUT /users/1.json
    def update
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to admin_user_path(@user), notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /users/1
    # DELETE /users/1.json
    def destroy
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def user_params
      permitted_params = [:name, :email, :password, :password_confirmation]

      permitted_params << :role if current_user.admin?
      permitted_params << {store_ids: []} if current_user.admin?

      params.require(:user).permit(permitted_params)
    end
  end
end