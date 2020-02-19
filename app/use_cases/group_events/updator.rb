module GroupEvents
  class Updator
    def initialize(group_event, params)
      @group_event = group_event
      @params = params
    end

    def call
      group_event.update_attributes(normalised_params)
    end

    def errors
      @errors ||= group_event.errors.full_messages unless group_event.valid?
    end

    private

    attr_reader :params, :group_event

    def normalised_params
      @normalised_params ||= ::GroupEvents::ParamsNormalisator.new(params).call
    end
  end
end
