module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instances
      @instances || 0
    end

    def increment_instances_count
      @instances ||= 0
      @instances += 1
    end
  end

  private

  module InstanceMethods
    def register_instance
      self.class.increment_instances_count
    end
  end
end
