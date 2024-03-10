FROM openjdk:17-jdk-slim

COPY target/app-management-0.0.1-SNAPSHOT.jar app-management-0.0.1-SNAPSHOT.jar

LABEL maintainer="thiaremohamed.mt@gmail.com"

RUN mkdir /app

ADD app-management-0.0.1-SNAPSHOT.jar /app/app-management-0.0.1-SNAPSHOT.jar

CMD ["java", "-jar", "/app/app-management-0.0.1-SNAPSHOT.jar"]