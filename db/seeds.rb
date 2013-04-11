# This file should contain all the record creation needed to seed the database
# with its default values.  The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).

target1 = 'demo.example1'
target2 = 'demo.example2'

d1 = Dashboard.create!(:name => 'Example 1 (Graph Widgets)')
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

d2 = Dashboard.create!(
  :name => 'Example 2 (Numbers, Boolean and Graph Widgets)'
)
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

d3 = Dashboard.create!(
  :name => 'Example 3 (Jenkins and Travis CI Builds)'
)
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

d4 = Dashboard.create!(:name => 'Example 4 (Meter, Alert)')
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

d5 = Dashboard.create!(:name => 'SUSE Studio Dashboard')
d5.widgets.create!(
  :name     => 'Production nodes',
  :kind     => 'table',
  :size_x   => 4,
  :size_y   => 3,
  :source   => 'chef'
)
