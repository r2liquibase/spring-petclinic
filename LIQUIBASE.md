### Notes on setting up "Prod" Database for Liquibase 

NOTE: we should probably delete this at some point


1. Start MySQL docker container. This will create an empty petclinic database.
2. Connect with DBeaver (or something else).
3. Execute src/main/resources/mysql SQL scripts, schema.sql and data.sql
4. Using liquibase.properties in the repos root execute `liquibase generate-changelog`. 
5. Assert that the changes in the new changelog.xml are already persisted to the database: execute `liquibase changelog-sync`
6. At this point, you can now make changes to the changelog.xml file, check in, and have automation update downstream databases.

To update the database using an existing changed database, compare to a database with an older schema. To do so, add the following to your liquibase.properties file:


```
referenceUrl: jdbc:mysql://<HOSTNAME>:<PORT>/<DATABASE>
referenceUsername: <USERNAME>
referencePassword: <PASSWORD>
```

Because we're using Spring Boot to call Liquibase at boot time, when we hit Production, we will only run the changesets that have NOT be executed yet.