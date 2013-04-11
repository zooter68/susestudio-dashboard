# Dashboard

Admin dashboard for managing the nodes in the SUSE Studio cluster, which
started as [a project]
(https://github.com/SUSE/hackweek/wiki/Admin-Dashboard) in SUSE's [Hackweek]
(http://hackweek.suse.com/). It is based off the awesome [Team Dashboard]
(https://github.com/fdietz/team_dashboard), so refer to that or the [old
README](doc/README-original.md) for related details.

## Getting started

1. Clone the repository:
   ```
   git clone git@github.com:susestudio/dashboard.git
   ```

1. Install dependencies with bundler:
   ```
   cd dashboard
   bundle install
   ```

1. Setup the PostgreSQL database and populate with seed data:
   ```
   sudo -u postgres createuser "$USER" -d
   bundle exec rake db:setup
   ```

1. Start the Rails server (at `http://localhost:3000`):
   ```
   bundle exec rails s
   ```

## Running tests

1. Install [PhantomJS](http://phantomjs.org/). It's not packaged on SUSE, so
   download the official tarball, untar it, and move the `phantomjs` binary to
   `~/bin/` (which should already be in your `$PATH`).

1. Now simply run `rake` to execute both the Ruby and Javscript tests:
   ```
   bundle exec rake
   ```
