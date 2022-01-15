# Bulk Discounts

### Turing 2110 Backend Module 2: [Bulk Discounts](https://backend.turing.edu/module2/projects/bulk_discounts)

## Schema

![Screen Shot 2022-01-14 at 4 48 16 PM](https://user-images.githubusercontent.com/89048720/149602188-388b80f6-46e1-465d-a32d-ce7ccd905acb.png)

## Description

This project is an extension of the Little Esty Shop group project. I added functionality for merchants to create bulk discounts for their items. A “bulk discount” is a discount based on the quantity of items the customer is buying, for example “20% off orders of 10 or more items”.

## Learning Goals
   - Write migrations to create tables and relationships between tables
   - Implement CRUD functionality for a resource using forms (form_tag or form_with), buttons, and links
   - Use MVC to organize code effectively, limiting the amount of logic included in views and controllers
   - Use built-in ActiveRecord methods to join multiple tables of data, make calculations, and group data based on one or more attributes
   - Write model tests that fully cover the data logic of the application
   - Write feature tests that fully cover the functionality of the application

## Setup/Testing

This project requires Ruby 2.7.2 and Rails 5.2.6 using PostgreSQL.

* Fork this repository
* Clone your fork
* From the command line, install gems and set up your DB:
    * `bundle`
    * `rails db:{drop,create,migrate,seed}`
    * `rake csv_load:all` (populate the database from pre-made CSV files)
* Run the test suite with `bundle exec rspec`.
* Run your development server with `rails s` to see the app in action.

## Author
- [Robin Dittrich](https://github.com/Dittrir)
