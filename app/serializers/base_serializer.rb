class BaseSerializer
  attr_accessor :m

  def initialize(model_instance)
    self.m = model_instance
  end

  def serialized_hash
    raise 'Implement #serialized_hash method'
  end

  def serialized_json
    serialized_hash.as_json
  end
end
