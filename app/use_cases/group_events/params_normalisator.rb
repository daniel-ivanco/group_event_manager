module GroupEvents
  class ParamsNormalisator
    def initialize(params)
      @params = params
    end

    def call
      return params_with_duration if params.has_key?(:start_date) && params.has_key?(:end_date) && !params.has_key?(:duration)
      return params_with_start_date if params.has_key?(:end_date) && params.has_key?(:duration) && !params.has_key?(:start_date)
      return params_with_end_date if params.has_key?(:start_date) && params.has_key?(:duration) && !params.has_key?(:end_date)
      params
    end

    private

    attr_reader :params

    def params_with_duration
      @params_with_duration ||= params.merge(duration: calculated_duration)
    end

    def params_with_start_date
      @params_with_start_date ||= params.merge(start_date: start_date)
    end

    def params_with_end_date
      @params_with_end_date ||= params.merge(end_date: end_date)
    end

    def calculated_duration
      @calculated_duration ||= (params[:end_date].to_date - params[:start_date].to_date).to_i
    end

    def duration
      @duration ||= params[:duration].to_i
    end

    def start_date
      @start_date ||= params[:end_date].to_date - duration.days
    end

    def end_date
      @end_date ||= params[:start_date].to_date + duration.days
    end
  end
end
