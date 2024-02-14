namespace :dev do
  desc "Configure the development environment"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Deleting DataBase...") { %x(rails db:drop) }
      show_spinner("Creating DataBase...") { %x(rails db:create) }
      show_spinner("Migrating DataBase...") { %x(rails db:migrate) }
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
    else
      puts "You´re not development environment mode!"
    end
  end

  desc "Add coins"
  task add_coins: :environment do
    show_spinner("Registering coins...") do
      coins = [
        new_coin("Bitcoin", "BTC", "https://cryptologos.cc/logos/bitcoin-btc-logo.png", MiningType.find_by(acronym: "PoW")),
        new_coin("Ethereum", "ETH", "https://e7.pngegg.com/pngimages/471/910/png-clipart-ethereum-classic-computer-icons-cryptocurrency-symbol-symbol-miscellaneous-blue.png"),
        new_coin("Solana", "SOL",  "https://cryptologos.cc/logos/solana-sol-logo.png"),
        new_coin("Dogecoin", "DOGE", "https://e7.pngegg.com/pngimages/140/487/png-clipart-dogecoin-cryptocurrency-digital-currency-doge-mammal-cat-like-mammal.png")
      ]

      coins.each do |coin|
        Coin.find_or_create_by!(description: coin.description, acronym: coin.acronym, url_image: coin.url_image, mining_type: coin.mining_type)
      end
    end
  end

  desc "Add mining types"
  task add_mining_types: :environment do
    show_spinner("Registering mining types...") do
      mining_types = [
        new_mining_type("Proof of Work", "PoW"),
        new_mining_type("Proof of Stake", "PoS"),
        new_mining_type("Proof of Capacity", "PoC")
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by(description: mining_type.description, acronym: mining_type.acronym)
      end
    end
  end

  private
    def show_spinner(message_start, message_end = "Done!")
      spinner = TTY::Spinner.new("[:spinner] #{message_start}")
      spinner.auto_spin
      yield
      spinner.success("(#{message_end})")
    end
      
    def new_coin(description, acronym, url_image, mining_type = MiningType.all.sample)
      coin = Coin.new
      coin.attributes = { description: description, acronym: acronym, url_image: url_image, mining_type: mining_type}
      coin
    end

    def new_mining_type(description, acronym)
      mining_type = MiningType.new
      mining_type.attributes = {description: description, acronym: acronym}
      mining_type
    end
end