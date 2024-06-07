require 'discordrb'
require 'dotenv/load'
require 'net/http'
require 'uri'
require 'json'
require 'openai'

# Tokens
DISCORD_TOKEN = ENV['DISCORD_TOKEN']
OPENAI_API_KEY = ENV['OPENAI_API_KEY']

# Open AI Configuration
openai_client = OpenAI::Client.new(api_key: OPENAI_API_KEY)

# Discord Bot Configuration
intents = [:servers, :server_messages, :server_message_reactions, :direct_messages, :direct_message_reactions]
bot = Discordrb::Bot.new token: DISCORD_TOKEN, intents: intents

#Function for text response
def get_gpt_response(user_message)
  uri = URI.parse("https://api.openai.com/v1/chat/completions")
  request = Net::HTTP::Post.new(uri)
  request.content_type = "application/json"
  request["Authorization"] = "Bearer #{ENV['OPENAI_API_KEY']}"
  request.body = JSON.dump({
                             "model" => "gpt-3.5-turbo",
                             "messages" => [
                               { "role" => "system", "content" => "You are a helpful assistant powered by GPT-3.5." },
                               { "role" => "user", "content" => user_message }
                             ]
                           })

  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  if response.code.to_i == 200
    result = JSON.parse(response.body)
    puts "OpenAI response: #{result}"
    result["choices"][0]["message"]["content"].strip
  else
    puts "Error with OpenAI API: #{response.code} - #{response.body}"
    "I'm having trouble thinking right now. Please try again later."
  end
end
# Function for image generation OpenAI DALL-E
def generate_image(prompt)
  uri = URI.parse("https://api.openai.com/v1/images/generations")
  request = Net::HTTP::Post.new(uri)
  request.content_type = "application/json"
  request["Authorization"] = "Bearer #{ENV['OPENAI_API_KEY']}"
  request.body = JSON.dump({
                             "prompt" => prompt,
                             "n" => 1,
                             "size" => "1024x1024"
                           })

  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  if response.code.to_i == 200
    result = JSON.parse(response.body)
    puts "OpenAI image response: #{result}"
    result["data"][0]["url"]
  else
    puts "Error with OpenAI API: #{response.code} - #{response.body}"
    "I'm having trouble generating an image right now. Please try again later."
  end
end

# Event: Bot is ready
bot.ready do
  puts "Logged in as #{bot.profile.username}"
end

# Event: Message
bot.message(in: '#chatgpt') do |event|
  next if event.author.bot_account?

  user_message = event.message.content
  puts "Received message: #{user_message}"

  if user_message.start_with?('!image')
    prompt = user_message.sub('!image', '').strip
    response = generate_image(prompt)
  else
    response = get_gpt_response(user_message)
  end

  puts "Sending response: #{response}"
  event.respond response
end

# Запуск бота
bot.run
