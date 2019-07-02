FROM openjdk:8-jdk-alpine
VOLUME /tmp
EXPOSE 5150
ARG JAR_FILE=spring-boot-service-*.jar
COPY ${JAR_FILE} /spring-boot-service.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/spring-boot-service.jar"]
