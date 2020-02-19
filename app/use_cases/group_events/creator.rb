module GroupEvents
  class Creator
    def initialize(params)
      @params = params
    end

    def call
      group_event.save
    end

    def group_event
      @group_event ||= GroupEvent.new(normalised_params)
    end

    def errors
      @errors ||= group_event.errors.full_messages unless group_event.valid?
    end

    private

    attr_reader :params

    def normalised_params
      @normalised_params ||= ::GroupEvents::ParamsNormalisator.new(params).call
    end
  end
end
