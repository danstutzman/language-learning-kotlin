`mvn compile`

Afterwards you can just run `./fastbuild run`

# How to delete database

`mvn flyway:clean`

# How to run migations

`mvn flyway:migrate jooq-codegen:generate`
