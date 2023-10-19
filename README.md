# README

## Rails Engine Lite
Rails Engine is a simple API built in rails to provide fictional data on merchants, items, invoices, etc.

## Technologies
Primary:
- Ruby 3.2.2
- Rails 7.0.8
- Postgresql
- Jsonapi-serializer

Testing:
- RSpec
- Shoulda-matchers
- FactoryBot
- Faker
- Pry

## Setup
- Fork/clone locally
- `bundle install` to install all dependencies
- `rails db:{drop,create,migrate,seed}` to build a seeded database (app is seeded via pgdump file in db/data)
- `rails db:schema:dump` to build the db schema file

## Endpoints
All endpoints assume the use of /api/v1. All endpoints are get unless otherwise specified.
- /merchants - fetch all merchants
- /merchants/:id - fetch a specific merchant
- /merchants/:id/items - fetch a specific merchant's items
- /merchants/find - search for a single merchant (accepts a query parameter of name)
- /items - fetch all items
- /items/:id - fetch a specific item
- /items/:id/merchant - fetch a specific item's merchant
- /items/find_all - search for all items by conditions (accepts query parameters of name or min_price/max_price. Cannot use both name and price together)
- post /items - create a new item (takes name, description, unit_price, merchant_id)
- put/patch /items/:id - update an existing item
- delete /items/:id - destroy an existing item