class EmailsController < ApplicationController

  def new
    @email = Email.new
    respond_to do |format|
      format.html #new.html.erb
      format.json { render json: @email}
    end
  end

  def create
    puts params[:email][:email]
    puts "PARAMS"
    @email = Email.new()
    @email.email = params[:email][:email]
    respond_to do |format|
      if @email.save
        format.html { redirect_to '/', notice: "Save process completed!" }
        format.json { render json: @email, status: :created, location: @email }
      else
        format.html {
          flash.now[:notice]="Save proccess coudn't be completed!"
          render :new
        }
        format.json { render json: @email.errors, status: :unprocessable_entity}
      end
    end
  end


end
