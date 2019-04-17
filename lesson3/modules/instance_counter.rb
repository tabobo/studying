module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :instances
    
    def instances_count
      @instances ||= 0
      @instances += 1
    end

    def instances
      @instances
    end
  end

  private
  module InstanceMethods
    def register_instance
      self.class.instances_count
    end
  end
  
end
