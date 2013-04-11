# Gives you the 'basic' new relic stats as numbers. All mushed into one file so that it
# makes a standalone plugin for the dashboard
#
# Valid Names are
#
# * Apdex
# * Response Time
# * Throughput
# * Memory
# * CPU
# * DB
#
module Sources
  module Number
    class NewRelic < Sources::Number::Base

      def fields
        [ { name: 'value_name', title: 'Value Name', mandatory: true } ]
      end

      def get(options = {})
        widget     = Widget.find(options.fetch(:widget_id))
        value_name = widget.settings.fetch(:value_name)

        value = get_value(value_name)
        case value_name
        when 'calls_per_minute'
          value = value.to_i
        when 'average_response_time'
          value = (value*1000).to_i
        end
        { value: value }
      end

      private

      def get_value(value_name)
        case value_name
        when 'Apdex'
          field   = 'value'
          metrics = value_name
        else
          field   = value_name
          metrics = 'HttpDispatcher'
        end
        response = conn.get(url, {
          :field   => field,
          :metrics => metrics,
          :begin   => format_time(Time.now-60),
          :end     => format_time(Time.now)
        })
        JSON.parse(response.body).last[field]
      end

      def conn
        conn = Faraday.new(url: 'https://api.newrelic.com')
        conn.headers['x-api-key'] = Settings.newrelic.api_key
        conn
      end

      def url
        '/api/v1/accounts/%d/applications/%d/data.json' % [
          Settings.newrelic.account_id,
          Settings.newrelic.application_id
        ]
      end

      def format_time(time)
        time.strftime('%Y-%m-%dT%H:%M:%SZ')
      end
    end
  end
end
