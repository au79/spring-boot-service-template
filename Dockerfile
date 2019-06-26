FROM openjdk:8-jdk-alpine
VOLUME /tmp
EXPOSE 5150
COPY ${JAR_FILE} /opt
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/opt/spring-boot-service-0.0.1-SNAPSHOT.jar"]
