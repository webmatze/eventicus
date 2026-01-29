# frozen_string_literal: true

module Events
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_event
    before_action :set_comment, only: :destroy

    def create
      @comment = @event.comments.build(comment_params)
      @comment.user = current_user

      respond_to do |format|
        if @comment.save
          format.turbo_stream
          format.html { redirect_to @event, notice: t("comments.created") }
        else
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "comment-form",
              partial: "events/comments/form",
              locals: { event: @event, comment: @comment }
            )
          end
          format.html { redirect_to @event, alert: @comment.errors.full_messages.join(", ") }
        end
      end
    end

    def destroy
      if @comment.user == current_user
        @comment.destroy
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to @event, notice: t("comments.deleted") }
        end
      else
        redirect_to @event, alert: t("comments.not_authorized")
      end
    end

    private

    def set_event
      @event = Event.friendly.find(params[:event_id])
    end

    def set_comment
      @comment = @event.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
  end
end
