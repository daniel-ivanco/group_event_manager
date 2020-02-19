module Api
  module V1
    class GroupEventsController < ApplicationController
      def index
        group_events = GroupEvent.enabled.order(created_at: :desc)
        render json: { message: 'events', data: group_events }, status: 200
      end

      def show
        group_event = GroupEvent.enabled.find(params[:id])
        render json: { message: 'event', data: group_event }, status: 200
      end

      def create
        group_event_creator = ::GroupEvents::Creator.new(event_params)
        if group_event_creator.call
          render json: {message: 'event created', data: group_event_creator.group_event }, status: 200
        else
          render json: { message: 'event not created', data: group_event_creator.errors }, status: 422
        end
      end

      def destroy
        group_event = GroupEvent.enabled.find(params[:id])
        group_event.disable!
        render json: { message: 'event deleted', data: group_event }, status: 200
      end

      def update
        group_event = GroupEvent.enabled.find(params[:id])
        group_event_updator = ::GroupEvents::Updator.new(group_event, event_params)

        if group_event_updator.call
          render json: { message: 'event updated', data: group_event }, status: 200
        else
          render json: { message: 'event not updated', data: group_event_updator.errors }, status: 422
        end
      end

      def publish
        group_event = GroupEvent.enabled.find(params[:id])
        if group_event.publish!
          render json: { message: 'event published', data: group_event }, status: 200
        else
          render json: { message: 'event not published', data: group_event.errors.full_messages }, status: 422
        end
      end

      private

      def event_params
        params.permit(:start_date, :end_date, :duration, :name, :description, :latitude, :longitude, :user_id)
      end
    end
  end
end
