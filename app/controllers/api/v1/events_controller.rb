class Api::V1::EventsController < ApplicationController

  # TODO: Add this back: 
  # before_action :restrict_access, :only => [:create, :update, :destroy]

  def index
    if params[:approved]=="false"
      @events = Event.where(:approved => false)
    else
      @events = Event.all
    end 
    render json: @events.paginate(per_page: 20, page: params[:page])
  end

  def create
    @event = Event.new(event_params)
    @event.save
  end

  def show
    @event = Event.find_by(:id => params[:id])
  end

  def update
    @event = Event.find_by(:id => params[:id])
    @event.update(event_params)
  end

  def destroy
    @event = Event.find_by(:id => params[:id])
    @event.destroy
    respond_with @event
  end

  def approve
    @event = Event.find_by(:id => params[:id])
    @event.update(:approved => true)
    respond_with @event
  end

  def deny
    @event = Event.find_by(:id => params[:id])
    @event.destroy
    respond_with @event
  end

end
