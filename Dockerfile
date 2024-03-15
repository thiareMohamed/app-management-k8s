FROM openjdk:17-jdk-slim

LABEL maintainer="thiaremohamed.mt@gmail.com"

RUN mkdir /app

EXPOSE 8081

ADD docker/app-management-0.0.1-SNAPSHOT.jar app-management-0.0.1-SNAPSHOT.jar

CMD ["java", "-jar", "-Dspring.profiles.active=prod", "app-management-0.0.1-SNAPSHOT.jar"]