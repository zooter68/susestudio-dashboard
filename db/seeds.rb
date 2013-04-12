# This file should contain all the record creation needed to seed the database
# with its default values.  The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).

include ActiveSupport::Benchmarkable

def logger
  @logger ||= Logger.new(STDOUT)
end

benchmark('Dashboard.delete_all') do
  Dashboard.delete_all
end
benchmark('Widget.delete_all') do
  Widget.delete_all
end
benchmark('Reset primary key sequences') do
  ActiveRecord::Base.connection.reset_pk_sequence!('dashboards')
  ActiveRecord::Base.connection.reset_pk_sequence!('widgets')
end

target1 = 'demo.example1'
target2 = 'demo.example2'

name = 'Example 1 (Graph Widgets)'
benchmark("Create dashboard: #{name}") do
  d1 = Dashboard.create!(:name => name)
  d1.widgets.create!(
    :name     => 'Single Target Line Graph',
    :targets  => target1,
    :size_x   => 1,
    :size_y   => 2,
    :source   => 'demo',
    :settings => { :graph_type => 'line' }
  )
  d1.widgets.create!(
    :name     => 'Two Targets Line Graph',
    :targets  => [target1, target2].join(';'),
    :size_x   => 2,
    :size_y   => 2,
    :source   => 'demo',
    :settings => { :graph_type => 'line' }
  )
  d1.widgets.create!(
    :name     => 'Two Targets Stacked Graph',
    :targets  => [target1, target2].join(';'),
    :size_x   => 3,
    :size_y   => 2,
    :source   => 'demo',
    :settings => { :graph_type => 'area' }
  )
end

name = 'Example 2 (Numbers, Boolean and Graph Widgets)'
benchmark("Create dashboard: #{name}") do
  d2 = Dashboard.create!(:name => name)
  d2.widgets.create!(
    :name     => 'Number',
    :kind     => 'number',
    :size_x   => 2,
    :source   => 'http_proxy',
    :settings => {
      :label            => 'Build duration (sec)',
      :proxy_url        => 'http://ci.jenkins-ci.org/job/infra_plugin_changes_report/lastBuild/api/json',
      :proxy_value_path => 'duration'
    }
  )
  d2.widgets.create!(
    :name     => 'Number',
    :kind     => 'number',
    :source   => 'demo',
    :settings => { :label => 'Errors per day' }
  )
  d2.widgets.create!(
    :name     => 'Number',
    :kind     => 'number',
    :source   => 'demo',
    :settings => { :label => 'Errors per minute' }
  )
  d2.widgets.create!(
    :name     => 'Boolean',
    :kind     => 'boolean',
    :source   => 'http_proxy',
    :settings => {
      :label            => 'Jenkins Status',
      :proxy_url        => 'http://ci.jenkins-ci.org/job/infra_plugin_changes_report/lastBuild/api/json',
      :proxy_value_path => 'building'
    }
  )
  d2.widgets.create!(
    :name     => 'Two Targets Stacked Graph',
    :targets  => [target1, target2].join(';'),
    :size_x   => 2,
    :size_y   => 2,
    :source   => 'demo',
    :settings => { :graph_type => 'area' }
  )
  d2.widgets.create!(
    :name     => 'Boolean',
    :kind     => 'boolean',
    :source   => 'demo',
    :settings => { :label => 'DB Health' }
  )
  d2.widgets.create!(
    :name     => 'Boolean',
    :kind     => 'boolean',
    :source   => 'demo',
    :settings => { :label => 'App Status' }
  )
end

name = 'Example 3 (Jenkins and Travis CI Builds)'
benchmark("Create dashboard: #{name}") do
  d3 = Dashboard.create!(:name => name)
  d3.widgets.create!(
    :name     => 'Jenkins',
    :kind     => 'ci',
    :source   => 'jenkins',
    :settings => {
      :server_url => 'http://ci.jenkins-ci.org/',
      :project    => 'infra_plugin-compat-tester'
    }
  )
  d3.widgets.create!(
    :name   => 'Travis CI',
    :kind   => 'ci',
    :source => 'travis',
    :settings => {
      :server_url => 'http://travis-ci.org',
      :project    => 'travis-ci/travis-ci'
    }
  )
end

name = 'Example 4 (Meter, Alert)'
benchmark("Create dashboard: #{name}") do
  d4 = Dashboard.create!(:name => name)
  d4.widgets.create!(
    :name     => 'Meter Example',
    :kind     => 'meter',
    :size_y   => 2,
    :source   => 'demo',
    :settings => { :label => 'Current Visitors' }
  )
  d4.widgets.create!(
    :name   => 'Alert',
    :kind   => 'alert',
    :source => 'demo',
    :size_x => 2
  )
end

name = 'SUSE Studio - Ops Dashboard'
benchmark("Create dashboard: #{name}") do
  d5 = Dashboard.create!(:name => name)
  d5.widgets.create!(
    :name     => 'UI Server',
    :kind     => 'meter',
    :source   => 'new_relic',
    :size_y   => 2,
    :settings => { label: 'Apdex', value_name: 'Apdex', min: 0, max: 1, step: 0.01 },
    :update_interval => 1.minute
  )
  d5.widgets.create!(
    :name     => 'UI Server (Avg response time)',
    :kind     => 'number',
    :source   => 'new_relic',
    :col      => 2,
    :row      => 1,
    :settings => { label: 'ms', value_name: 'average_response_time' },
    :update_interval => 1.minute
  )
  d5.widgets.create!(
    :name     => 'UI Server',
    :kind     => 'number',
    :source   => 'new_relic',
    :col      => 2,
    :row      => 2,
    :settings => { label: 'Reqs / min', value_name: 'calls_per_minute' },
    :update_interval => 1.minute
  )
  d5.widgets.create!(
    :name     => 'Cluster load',
    :targets  => [target1, target2].join(';'),
    :size_x   => 2,
    :size_y   => 2,
    :col      => 3,
    :row      => 1,
    :source   => 'demo',
    :settings => { :graph_type => 'area' }
  )
  d5.widgets.create!(
    :name     => 'Production nodes',
    :kind     => 'table',
    :size_x   => 4,
    :size_y   => 4,
    :source   => 'chef',
    :settings => { displayed_rows: 21 },
    :update_interval => 10.minutes
  )
end
