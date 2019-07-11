FROM openjdk:8-jdk-alpine
VOLUME /tmp
EXPOSE 5150
COPY build/libs/spring-boot-service-*.jar /spring-boot-service.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/spring-boot-service.jar"]
