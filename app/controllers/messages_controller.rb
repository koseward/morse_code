class MessagesController < ApplicationController
  allow_unauthenticated_access only:  %i[ index show ]
  before_action :set_message, only: %i[ show edit update destroy]

  def index
    @messages = Message.all
  end

  def show
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to @message
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @message.update(message_params)
      redirect_to @message
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @message.destroy
    redirect_to messages_path
  end

  private
  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.expect(message: [ :contents ])
  end
end
