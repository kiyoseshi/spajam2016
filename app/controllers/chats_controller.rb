class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :edit, :update, :destroy]

  # GET /chats
  # GET /chats.json
  def index
    @msg = {}
    wit_actions = {
      :say => -> (session_id, context, msg) {
        @msg['message'] = msg
      },
      :merge => -> (session_id, context, entities, msg) {

        loc = nil if entities.has_key?('location')
        val = entities['location'][0]['value'] unless loc.nil?
        loc =  nil if val.nil?
        unless val.nil?
          loc =  val.is_a?(Hash) ? val['value'] : val
        end

        context['loc'] = loc unless loc.nil?
        return context
      },
      :error => -> (session_id, context, error) {
        p error.message
      },
      :'fetch-weather' => -> (session_id, context) {
        context['forecast'] = 'sunny'
        return context
      },
    }
    @chats = Chat.all
    wit = Wit.new('Y3SKN3OLWR3LT57GRVRR6EZNAQF7MMMG', wit_actions)
    message = wit.message("What's the weather?")
    @text = message['outcomes'][0]['_text']
    @run_actions = wit.run_actions('123abc', {}, {})
  end

  # GET /chats/1
  # GET /chats/1.json
  def show
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats
  # POST /chats.json
  def create
    @chat = Chat.new(chat_params)

    respond_to do |format|
      if @chat.save
        format.html { redirect_to @chat, notice: 'Chat was successfully created.' }
        format.json { render :show, status: :created, location: @chat }
      else
        format.html { render :new }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chats/1
  # PATCH/PUT /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to @chat, notice: 'Chat was successfully updated.' }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1
  # DELETE /chats/1.json
  def destroy
    @chat.destroy
    respond_to do |format|
      format.html { redirect_to chats_url, notice: 'Chat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chat_params
      params.fetch(:chat, {})
    end
end
