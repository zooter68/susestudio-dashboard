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

1. Setup the PostgreSQL database and populate with sample data:
   ```
   sudo -u postgres createuser "$USER" -d
   rake db:setup populate
   ```

1. Start the Rails server (at `http://localhost:3000`):
   ```
   rails s
   ```
