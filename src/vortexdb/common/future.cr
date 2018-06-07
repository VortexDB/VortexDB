# Lightweight future
class Future(T)
  # Is future complete
  @complete = false

  # Error
  @error : Exception?

  # Result of future
  @result : T?

  # Block to catch
  @catchBlock : Proc(Exception, Void)?

  # Wait all futures
  def self.waitAll(*futures)
    return futures.map do |f|
      f.wait
    end
  end

  # Start delayed future
  def self.delayed(duration : Time::Span, &block : -> T) : Future(T)
    # TODO: rework
    sleep duration.total_seconds
    return Future(T).new &block
  end

  # Constructor
  def initialize(&block : -> T)
    spawn do
      begin
        @result = block.call
        @complete = true
      rescue e : Exception
        @error = e
        @complete = true
        @catchBlock.try &.call(e)
        @error = nil
      end      
    end
  end

  # Future after
  def then(&block : T -> _) : Future
    return Future.new do        
        block.call(self.wait)
    end
  end

  # Catch exception
  def catch(&block : Exception -> _) : Future
    @catchBlock = block
    self
  end

  # Wait future
  def wait : T
    while !@complete || !@error.nil?
      Fiber.yield
    end
    raise @error.not_nil! if !@error.nil?
    @result.not_nil!
  end
end