library(telegram.bot)

# handler functions

start <- function(bot, update) {
  bot$sendMessage(
    chat_id = update$message$chat_id,
    text = sprintf(
      "Welcome %s to the *Telegram Bot R Application* on _Heroku_!",
      update$message$from$first_name
    ),
    parse_mode = "Markdown"
  )

  bot$sendMessage(
    chat_id = update$message$chat_id,
    text = "Send `/plot` or just a message.",
    parse_mode = "Markdown"
  )
}

plot <- function(bot, update) {
  file <- tempfile("plot", fileext="png")
  png(file, units="px", bg="white", width=500, height=500)
  par(mar=c(2, 2, 4, 2))

  slices <- c(10, 12,4, 16, 8)
  lbls <- c("US", "UK", "Australia", "Germany", "France")

  pie(slices, labels=lbls, main="Pie Chart of Countries")

  dev.off()

  bot$sendPhoto(
    chat_id = update$message$chat_id,
    caption = "Example plot",
    photo = file
  )
}

echo <- function(bot, update){
  bot$sendMessage(
    chat_id = update$message$chat_id,
    text = sprintf(
      "You sent this message:\n\n> %s",
      update$message$text
    ),
    parse_mode = "Markdown"
  )
}

# obtain token from environment variable
token <- Sys.getenv("TELEGRAM_TOKEN")

# instantiate bot
bot <- Bot(token=token)

# create updater, which uses long polling to retrieve messages
# and dispatches them to handler functions
updater <- Updater(bot=bot)

# wire up handlers
updater <- updater + CommandHandler("start", start)
updater <- updater + CommandHandler("plot", plot)
updater <- updater + MessageHandler(echo, MessageFilters$text)

# start polling for messages
updater$start_polling(verbose = TRUE)

# TODO: error handling and clean exit
