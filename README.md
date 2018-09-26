# How to run locally

- First time only or after a clean:
  - `mkdir -p target/generated-sources/grammars/com/danstutzman/arabic`
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

If you get an error, you might need to run `rm target/generated-sources/grammars/com/danstutzman/arabic/BuckwalterToQalamParser.java`
