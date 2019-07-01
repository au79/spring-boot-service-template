FROM openjdk:8-jdk-alpine
VOLUME /tmp
EXPOSE 5150
COPY ${JAR_FILE} /opt
ENV JAR_FILE "${JAR_FILE}"
ENTRYPOINT exec java -Djava.security.egd=file:/dev/./urandom -jar "/opt/${JAR_FILE}"
