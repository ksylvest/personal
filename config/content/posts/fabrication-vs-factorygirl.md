---
date: "2017-08-12"
title: Fabrication vs FactoryGirl
summary: A deep dive into the performance of Fabrication and FactoryGirl.
tags:
  - ruby
  - rails
  - fabrication
  - factorygirl
  - benchmarking
---

The ability to generate testing data via a simple syntax is something offered by both [Fabrication](https://www.fabricationgem.org/) and [FactoryBot](https://github.com/thoughtbot/factory_bot). So which is faster?

# The Setup

To test the performance a simple schema is generated containing a few different models:

```bash
rails generate model address street:string city:string state:string postal:string
```

```ruby
class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :street, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :country, null: false
      t.string :postal, null: false
      t.timestamps
    end
  end
end
```

```ruby
class Address < ApplicationRecord
  has_one :company
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :postal, presence: true
end
```

```bash
rails generate model company name:string address:references
```

```ruby
class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false, index: { unique: true }
      t.references :address, null: false, index: true
      t.timestamps
    end
    add_foreign_key :companies, :addresses
  end
end
```

```ruby
class Company < ApplicationRecord
  belongs_to :address
  has_many :employees
  validates :name, presence: true, uniqueness: true
end
```

```bash
rails generate model employee name:string email:string company:references
```

```ruby
class CreateEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.references :company, null: false
      t.timestamps
    end
    add_foreign_key :employees, :companies
  end
end
```

```ruby
class Employee < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  belongs_to :company
end
```

Then identical factories / fabricators are defined:

```ruby
Fabricator(:address) do
  street '123 Sandhill Road'
  city 'Whitehorse'
  state 'Yukon'
  country 'Canada'
  postal '00000'
end

FactoryBot.define do
  factory :address do
    street '123 Sandhill Road'
    city 'Whitehorse'
    state 'Yukon'
    country 'Canada'
    postal '00000'
  end
end

Fabricator(:company) do
  name { sequence { |index| "Company ##{index}" } }
  address
end

FactoryBot.define do
  factory :company do
    sequence(:name) { |index| "Company ##{index}" }
    association :address, strategy: :build
  end
end

Fabricator(:employee) do
  name { sequence { |index| "Employee ##{index}" } }
  email { sequence { |index| "#{index}@fake.host" } }
  company
end

FactoryBot.define do
  factory :employee do
    sequence(:name) { |index| "Employee ##{index}" }
    sequence(:email) { |index| "#{index}@fake.host" }
    association :company, strategy: :build
  end
end
```

# The Benchmarks

A mixture of **create** and **build** is used via benchmark (with `bmbm` for warming) to profile the differences between Fabricator and FactoryBot over a variety of factories and fixtures. The benchmarks run in a joinable transaction (similar to how they would be invoked in a testing environment).

```ruby
require 'benchmark'

ITERATIONS = 50_000

def autorollback
  ApplicationRecord.transaction(joinable: true) do
    yield
    raise ActiveRecord::Rollback
  end
end

Benchmark.bmbm(32) do |benchmark|
  [Fabricate, FactoryBot].each do |service|
    %i[address company employee].each do |resource|
      benchmark.report("#{service}.build(#{resource.inspect})") do
        ITERATIONS.times { autorollback { service.build(resource) } }
      end
      benchmark.report("#{service}.create(#{resource.inspect})") do
        ITERATIONS.times { autorollback { service.create(resource) } }
      end
    end
  end
end
```

# The Results

The following results are measured in seconds (so less is more):

```bash
                                       user     system      total        real
Fabricate.build(:address)         25.620000   2.340000  27.960000 ( 30.918019)
Fabricate.create(:address)        62.510000   6.780000  69.290000 ( 79.881861)
Fabricate.build(:company)         31.290000   2.230000  33.520000 ( 36.253026)
Fabricate.create(:company)       134.810000  12.270000 147.080000 (173.582866)
Fabricate.build(:employee)        40.980000   2.300000  43.280000 ( 46.014712)
Fabricate.create(:employee)      220.580000  19.250000 239.830000 (286.526900)
FactoryBot.build(:address)       24.420000   2.070000  26.490000 ( 29.069839)
FactoryBot.create(:address)      61.420000   6.440000  67.860000 ( 77.759625)
FactoryBot.build(:company)       34.430000   2.210000  36.640000 ( 39.499374)
FactoryBot.create(:company)     173.610000  14.070000 187.680000 (221.798007)
FactoryBot.build(:employee)      45.290000   2.290000  47.580000 ( 50.445987)
FactoryBot.create(:employee)    256.920000  20.540000 277.460000 (330.741249)
```

## Seconds to Build (50,000 entries)

```
| Resource | Fabricate | FactoryBot |
-------------------------------------
| Address  | 25.62     | 24.42      |
| Company  | 31.29     | 34.43      |
| Employee | 40.98     | 45.29      |
```

## Seconds to Create (50,000 entries)

```
| Resource | Fabricate | FactoryBot |
-------------------------------------
| Address  | 62.51     | 61.42      |
| Company  | 134.81    | 173.61     |
| Employee | 220.58    | 256.92     |
```

## Seconds to Build vs Create (50,000 entries)

```
| Resource | Build (Fabricate) | Build (FactoryBot) | Create (Fabricate) | Create (FactoryBot) |
| Address  | 25.62             | 24.42              | 62.51              | 61.42               |
| Company  | 31.29             | 34.43              | 134.81             | 173.61              |
| Employee | 40.98             | 45.29              | 220.58             | 256.92              |
```

## Summary

Fabricate has a slight advantage over FactoryBot for building and creating nested resources. For non nested resources they are comparable. Given that the difference is less than ten percent selection can probably ignore performance. The more interesting result is the difference between **build** and **create**. The vast performance improvements outlines the importance of selecting **build** over **create** whenever possible (likely primarily in unit test).
