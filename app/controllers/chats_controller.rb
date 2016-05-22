class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :edit, :update, :destroy]

  def index
    if session[:chat].nil?
      @chat = Chat.new()
    else
      @bot = Chat.new({'content' => session[:chat]['content']})
      @chat = Chat.new()
      session[:chat] = nil
    end
  end

  def first_entity_value(entities, entity)
    return nil unless entities.has_key? entity
    val = entities[entity][0]['value']
    return nil if val.nil?
    return val.is_a?(Hash) ? val['value'] : val
  end

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
    run_actions = wit.run_actions('123abc', chat.content, {})
    bot = Chat.new({"content" => @msg["message"], "user_type" => "bot"})
    session[:chat] = {'content' => @msg["message"]}
    redirect_to root_path
  end

  private
    def set_chat
      @chat = Chat.find(params[:id])
    end

    def chat_params
      params.require(:chat).permit(:content, :user_type)
    end
end
