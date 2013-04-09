module Sources
  module Table
    class Datapoints < Sources::Table::Base

      def get(options = {})
        widget             = Widget.find(options.fetch(:widget_id))
        datapoints_source  = widget.settings.fetch(:datapoints_source)

        plugin = Sources.plugin_clazz('datapoints', datapoints_source).new
        result = plugin.get(options.merge(:source => datapoints_source))

        datapoints_for_all_targets = result.map { |r| r[:datapoints] }
        datapoints = datapoints_for_all_targets.inject([]) { |result, v| result += v; result }

        { columns: ["Y", "X"],
          rows: datapoints }
      end

    end
  end
end
