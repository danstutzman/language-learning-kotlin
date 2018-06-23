`mvn compile`

Afterwards you can just run `./fastbuild run`

# How to delete database

`mvn flyway:clean`

# How to run migations

`mvn flyway:migrate jooq-codegen:generate`

# How to run JUnit tests

`mvn test -Dtest=*`

Or run `./fastbuild test`
