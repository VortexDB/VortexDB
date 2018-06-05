# Исключение
class VortexException < Exception
    # Сообщение без Nil
    def message! : String
        message.not_nil!
    end

    # Конструктор    
    def initialize(message)
        super(message)
    end
end