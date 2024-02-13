module ApplicationHelper
    def locale
        I18n.locale == :en ? "Estados Unidos" : "Português do Brasil" 
    end

    def environment_rails
        if Rails.env.development?
            "Desenvolvimento"
        elsif Rails.env.production? 
           "Produção"
        else
            "Teste"
        end 
    end
end
