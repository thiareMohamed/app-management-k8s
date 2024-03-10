FROM openjdk:17-jdk-slim

LABEL maintainer="thiaremohamed.mt@gmail.com"

RUN mkdir /app

ADD target/app-management-0.0.1-SNAPSHOT.jar app-management-0.0.1-SNAPSHOT.jar

CMD ["java", "-jar", "app-management-0.0.1-SNAPSHOT.jar"]