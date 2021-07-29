FROM openjdk:8-jre

COPY target/*.jar gestion-signalement-0.0.1-SNAPSHOT.jar

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/.urandom","-jar","/gestion-signalement-0.0.1-SNAPSHOT.jar"]