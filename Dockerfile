FROM maven:3.9.9 AS builder
WORKDIR /app

COPY . .

RUN mvn clean package

FROM tomcat:9

COPY --form=builder /app/target/*.war /usr/local/tomcat/webapps/appjsp