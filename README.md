# Simple ChatGPT Discord Bot Setup Instructions

1. Create `.env` File
    - In your project's root directory, create a `.env` file.

2. Define Constants
    - Add the following lines to your `.env` file:
      DISCORD_TOKEN=your_discord_bot_token
      OPENAI_API_KEY=your_openai_api_key

3. Create a Discord Application
    - Go to: https://discord.com/developers/applications
    - Create a new application and a new bot.
    - Copy the bot token.
    - Paste the bot token in the `.env` file after `DISCORD_TOKEN=`.

4. Set Up OpenAI API Key
    - Visit: https://platform.openai.com/
    - Navigate to 'API Keys' and generate a new key.
    - Add the key to your `.env` file after `OPENAI_API_KEY=`.

5. Add Bot to Discord Server
    - In the Discord Developer Portal, under 'OAuth2' -> 'URL Generator':
        - Select 'bot' under scopes.
        - Choose the necessary permissions under 'Bot Permissions'.
        - Use the generated URL to invite your bot.

6. Configure the Channel
    - On your server, create a channel named `#chatgpt` or modify the channel name in the event message handling (line 86 in `bot.rb`).

7. Start Your Bot
    - Run `ruby bot.rb` in your terminal to start your bot.
