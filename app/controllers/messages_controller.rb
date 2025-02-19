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
    @message.translated_message = translate_message @message.contents
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

  def translate_message(message)
    result = ""
    message.split("       ").each do |word|
      word.split(" ").each do |character|
        result = result + morse_code_dictionary[character.to_sym]
      end
    end
    result
  end

  def message_params
    params.expect(message: [ :contents ])
  end

  def morse_code_dictionary
    {
     ".-": "A",
     "-...": "B",
     "-.-.": "C",
     "-..": "D",
     ".": "E",
     "..-.": "F",
     "--.": "G",
     "....": "H",
     "..": "I",
     ".---": "J",
     "-.-": "K",
     ".-..": "L",
     "--": "M",
     "-.": "N",
     "---": "O",
     ".--.": "P",
     "--.-": "Q",
     ".-.": "R",
     "...": "S",
     "-": "T",
     "..-": "U",
     "...-": "V",
     ".--": "W",
     "-..-": "X",
     "-.--": "Y",
     "--..": "Z",
     ".----": "1",
     "..---": "2",
     "...--": "3",
     "....-": "4",
     ".....": "5",
     "-....": "6",
     "--...": "7",
     "---..": "8",
     "----.": "9",
     "-----": "0",
     ".-.-.-": ".",
     "--..--": ",",
     "..--..": "?",
     "---...": ":",
     "-.-.-.": ";",
     "-....-": "-",
     ".-..-.": '"',
     "-.-.--": "!"
    }
  end
end
