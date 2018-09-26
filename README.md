# How to run locally

- First time only or after a clean:
  - `mvn mouse:generate compile`
- Every time: `./fastbuild run`

# How to delete database

`mvn flyway:clean`

# How to run migations

`mvn flyway:migrate jooq-codegen:generate`

# How to run JUnit tests

`mvn test -Dtest=*`

Or run `./fastbuild test`

# How to regenerate MousePEG parser

`mvn mouse:generate`
