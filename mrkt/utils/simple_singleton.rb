module SimpleSingleton

  def method_missing method, *args
    instance.send(method, *args)
  end

  def instance
    @instance ||= self.new
  end

end
