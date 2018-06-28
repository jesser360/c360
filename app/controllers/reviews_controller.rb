class ReviewsController < ApplicationController


  # POST /Reviews
  # POST /Reviews.json
  def create
    @review = Review.new()
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    @item = Item.find_by_id(params[:item])

    @review.user = @user
    @review.item = @item
    if params[:bulk]
      @review.bulk_order = BulkOrder.find_by_id(params[:bulk])
    else
      @review.user_order = UserOrder.find_by_id(params[:user_order])
    end
    @review.rating = params[:rating]
    @review.body = params[:body]
    @review.title = params[:title]
    @item.rating += @review.rating
    @item.rating_count += 1
    @item.save

    respond_to do |format|
      if @review.save
        format.html { redirect_to item_path(@item)}
        format.json { render :show, status: :created, location: @item }
      else
        puts @review.errors.messages
        # format.html { render :new }
        # format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end


end
