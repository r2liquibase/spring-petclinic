#Example format of using virtual repo from JFrog Artifactory
#to pull and cache from remote repo (Docker Hub)
#FROM myartifactory.jfrog.io/petclinic-docker/openjdk:8 AS builder
FROM openjdk:8 AS builder
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline -Dcheckstyle.skip -DskipTests
COPY src ./src
RUN ./mvnw package -Dcheckstyle.skip -DskipTests

WORKDIR target/dependency/
RUN jar -xf ../*.jar

#Example format of using virtual repo from JFrog Artifactory
#to pull and cache from remote repo (Docker Hub)
#FROM myartifactory.jfrog.io/petclinic-docker/openjdk:8-jdk-alpine
FROM openjdk:8-jdk-alpine
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
ARG DEPENDENCY=/app/target/dependency
COPY --from=builder ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=builder ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=builder ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT ["java","-cp", "app:app/lib/*", "org.springframework.samples.petclinic.PetClinicApplication"]
CMD ["--spring.profiles.active=mysql"]
