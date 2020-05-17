# frozen_string_literal: true

class TestFactories
  def call_attempts
    @call_attempts ||= CallAttemptFactory.new(self)
  end

  def phones
    @phones ||= PhoneFactory.new(self)
  end

  def territories
    @territories ||= TerritoryFactory.new(self)
  end

  def users
    @users ||= UserFactory.new(self)
  end

  class Factory
    attr_reader :factories

    def initialize(factories)
      @factories = factories
      @sequency = 0
    end

    def sequency
      @sequency += 1
    end

    def seq
      sequency
    end

    def create(overrides = {})
      model_class.create!(attributes.merge(overrides))
    end

    def build(overrides = {})
      model_class.new(attributes.merge(overrides))
    end

    private

    def model_class
      @model_class ||= self.class.to_s.sub('TestFactories::', '').sub('Factory', '').constantize
    end
  end

  class UserFactory < Factory
    def attributes(overrides = {})
      { name: "User-#{seq}" }.merge(overrides)
    end
  end

  class TerritoryFactory < Factory
    def attributes(overrides = {})
      {
        name: "T-#{seq}"
      }.merge(overrides)
    end
  end

  class PhoneFactory < Factory
    def attributes(overrides = {})
      {
        number: "#{seq}-111",
        territory: overrides[:territory] || factories.territories.create
      }.merge(overrides)
    end
  end

  class CallAttemptFactory < Factory
    def create_not_home(overrides = {})
      create(overrides.merge(outcome: 'not_home'))
    end

    def create_return_visit(overrides = {})
      create(overrides.merge(outcome: 'contacted', return_visit: true))
    end

    def create_do_not_call(overrides = {})
      create(overrides.merge(outcome: 'contacted', return_visit: false))
    end

    def attributes(overrides = {})
      {
        user: overrides[:user] || User.new,
        phone: overrides[:phone] || @factories.phones.create,
        outcome: 'contacted',
        gender: %w[male female].sample,
        notes: "nice talk #{seq}"
      }.merge(overrides)
    end
  end
end
