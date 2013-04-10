namespace :chef do
  namespace :nodes do

    extend ActiveSupport::Benchmarkable

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    desc "Drop all Chef nodes. Check that you're connected to a demo Chef server!"
    task drop: :environment do
      Chef.node.all.each do |node|
        benchmark("Deleted #{node.name}") { Chef.node.delete(node.name) }
      end
    end

    desc "Add demo Chef nodes. Check that you're connected to a demo Chef server!"
    task load: :environment do
      for i in 1..80
        node_name = sprintf("node%02d", i)
        benchmark "Created #{node_name}" do
          begin
            Chef.node.create(name: node_name)
          rescue Ridley::Errors::HTTPConflict => ex
            raise ex unless ex.message =~ /Node already exists/
          end
        end
      end
    end

    desc "Reset demo Chef nodes. Check that you're connected to a demo Chef server!"
    task reset: [ :drop, :load ] do
    end
  end
end
