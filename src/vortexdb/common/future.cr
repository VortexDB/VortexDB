# Lightweight future
class Future(T)
  @channel = Channel(T | Nil).new

  # Is future complete
  @complete = false

  # Error
  @error : Exception?

  # Result of future
  @result : T?

  # Block to catch
  @catchBlock : Proc(Exception, Void)?

  # Block on complete
  @completeBlock : (-> Void)?

  # Wait all futures
  def self.waitAll(*futures)
    return futures.map do |f|
      f.wait
    end
  end

  # Start delayed future
  def self.delayed(duration : Time::Span, &block : -> T) : Future(T)
    return Future(T).new do
      sleep duration.total_seconds
      block.call
    end
  end

  private def run(&block : -> T)
    spawn do
      begin
        @result = block.call
        @complete = true
        @channel.send(@result)
      rescue e : Exception
        @error = e
        @complete = true
        @catchBlock.try &.call(e)
        @channel.send(nil)
      end
    end
  end

  # Constructor
  def initialize(&block : -> T)
    run(&block)
  end

  # Future after
  def then(&block : T? -> _) : Future
    return Future.new do
      block.call(self.wait)
    end
  end

  # Catch exception
  def catch(&block : Exception -> _) : Future
    @catchBlock = block
    self
  end

  # On complete with result o not
  def whenComplete(&block : -> _) : Future
    return Future.new do
      begin
        self.wait
      rescue e : Exception
        raise e
      ensure
        block.call
      end
      Nil
    end
  end

  # Wait for complete
  def wait : T?
    @channel.receive
  end
end

# Future completer
class Completer(T)
  # Future to complete
  getter future : Future(T)

  # Is completed
  @channel = Channel(T).new

  def initialize
    @future = Future(T).new do
      value = @channel.receive
      value
    end
  end

  # Complete future
  def complete(value : T)
    @channel.send(value)
  end
end