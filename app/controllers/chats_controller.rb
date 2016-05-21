class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :edit, :update, :destroy]

  def index
    @chats = Chat.all
    @chat = Chat.new()
  end

  def first_entity_value(entities, entity)
    return nil unless entities.has_key? entity
    val = entities[entity][0]['value']
    return nil if val.nil?
    return val.is_a?(Hash) ? val['value'] : val
  end

  def set_context(entities, entity)
    loc =  nil unless entities.has_key? entity
    val = entities['location'][0]['value'] unless loc.nil?
    loc =  nil if val.nil?
    unless val.nil?
      loc =  val.is_a?(Hash) ? val['value'] : val
    end
    context['loc'] = loc unless loc.nil?
  end

  # loc = first_entity_value entities, 'location'
  # context['loc'] = loc unless loc.nil?
  # return context

  def create
    chat = Chat.new(chat_params)
    @msg = {}
    wit_actions = {
      :say => -> (session_id, context, msg) {
        @msg['message'] = msg
      },
      :merge => -> (session_id, context, entities, msg) {
        loc = first_entity_value entities, 'location'
        context['loc'] = loc unless loc.nil?
        gintama = first_entity_value entities, 'gintama'
        context['gintama'] = gintama unless gintama.nil?
        kimono = first_entity_value entities, 'kimono'
        context['kimono'] = kimono unless kimono.nil?
        return context
      },
      :error => -> (session_id, context, error) {
        p error.message
      },
    }
    wit = Wit.new('NXJJAH33CJFJUHCX7XXRGILI3MW5WWS5', wit_actions)
    @run_actions = wit.run_actions('123abc', {}, {})
    message = wit.message(chat.content)
    run_actions = wit.run_actions('123abc', {}, {})
    bot = Chat.new({"content" => @msg["message"], "user_type" => "bot"})
    if bot.save
      redirect_to chats_path
    else
      render :index
    end
  end

  private
    def set_chat
      @chat = Chat.find(params[:id])
    end

    def chat_params
      params.require(:chat).permit(:content, :user_type)
    end
end
