$(".chute").html("<%= escape_javascript(render(partial: 'messages/chat_message', collection: @chat_messages)) %>")
$("#subj").html("<%= @chat_messages.first.subject %>")