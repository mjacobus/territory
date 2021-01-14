# Territory

Simple app for managing the congregation territories.

[![Build Status](https://travis-ci.org/mjacobus/territory.svg?branch=master)](https://travis-ci.org/mjacobus/territory)
[![Maintainability](https://api.codeclimate.com/v1/badges/17449aaca20504da468f/maintainability)](https://codeclimate.com/github/mjacobus/territory/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/mjacobus/territory/badge.svg)](https://coveralls.io/github/mjacobus/territory)


### How to run/install the app:

After installing the ruby version displayed in [this file](https://github.com/mjacobus/territory/blob/master/.ruby-version).
Also install `nodejs` and `yarn`.

```bash
# first time
gem install bundler
mkdir ~/Projects
cd projects
git clone https://github.com/mjacobus/territory.git
cd territory
bundle install # after you installed ruby version
cp .env.sample .env

yarn install

# every time you update your project

cd ~/Projects/territory
bundle install
./bin/rake db:create  # create database
./bin/rake db:migrate # create tables
./bin/rake db:seed    # create fake data for the database

./bin/rails server    # to stop the server hit <ctrl>+C
```

### Running tests

```bash
RAILS_ENV=test ./bin/rake db:create  # create test database
RAILS_ENV=test ./bin/rake db:migrate # create test tables
./bin/rspec
```

### Fixing files style after changing

```bash
bundle exec rubocop -a
```





### Installing OS dependencies

- If you are on [Ubuntu 18.04 LTS](https://github.com/mjacobus/installers/tree/master/ubuntu/18.04)
- The above step is not installing ruby itself. However you can try to use [asdf for ruby](https://github.com/asdf-vm/asdf-ruby).
- Same for nodejs and yarn. Try [asdf for nodejs](https://github.com/asdf-vm/asdf-nodejs) and after installing run `npm install -g yarn`.

## Heroku

- [DB Backups](https://data.heroku.com/datastores/6d47c6e8-812a-4559-9fbe-42ac5ebbd428#durability)

```bash
pg_restore -U pguser -W --no-owner --no-privileges -h localhost -d territory_manager_development -1 tmp/bkp/jw-territory-backup-21-01-14
```
