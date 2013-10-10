module Lookupable
  module ClassMethods
    def [](name)
      if name.is_a? self
        self
      elsif name.is_a? Integer
        self.where(["id = ?", id]).first
      else
        self.where(["lower(name) = ?", name.to_s.strip.downcase]).first
      end
    end

    def find_by_name(name)
      self.where(["lower(name) = ?", name.to_s.strip.downcase]).first
    end

    #def ==(other)
      #if other.is_a? self.class
      #  self.id == other.id
      #elsif other.is_a? String
      #  self.name == other.strip.downcase
      #else
      #  self == other
      #end
      #
      #if other.is_a? String
      #  self.name == other.strip.downcase
      #else
      #  self == other
      #end
    #end
  end

  module InstanceMethods
    def to_s
      name
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods

    receiver.class_eval do
      validates_presence_of :name, on: :create, message: "can't be blank"
      validates_uniqueness_of :name, on: :create, message: "must be unique", case_sensitive: false
    end
  end
end