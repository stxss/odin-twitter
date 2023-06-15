class LikesController < ApplicationController
  def create
    @like = current_user.like_tweet(like_params)
    @tweet = Tweet.find(like_params[:tweet_id])

    respond_to do |format|
      if @like.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.update("like_count_#{@tweet.id}", partial: "tweets/like_count", locals: {tweet: @tweet}),
            turbo_stream.update("like_#{@tweet.id}", partial: "tweets/unlike_button", locals: {tweet: @tweet})
          ]
        }
        format.html { redirect_to request.referrer }
        current_user.notify(@tweet.author.id, :like, tweet_id: @tweet.id)
      # else
        # flash.now[:alert] = "Oops, something went wrong, check your fields again"
        # render :edit, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.remove("tweet_#{like_params[:tweet_id]}"),
          flash.now[:alert] = "Couldn't like"
        ]
      }
    end
  end

  def destroy
    @tweet = Tweet.find(like_params[:tweet_id])
    @like = current_user.liked_tweets.find_by(tweet: @tweet)

    respond_to do |format|
      if @like.destroy
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.update("like_count_#{@tweet.id}", partial: "tweets/like_count", locals: {tweet: @tweet}),
            turbo_stream.update("like_#{@tweet.id}", partial: "tweets/like_button", locals: {tweet: @tweet})
          ]
        }
        format.html { redirect_to request.referrer }
        @tweet.author.notifications_received.where(notifier_id: current_user.id, notification_type: :like, tweet_id: @tweet.id).destroy_all
      end
    end
  end

  private

  def like_params
    params.require(:like).permit(:tweet_id)
  end
end
