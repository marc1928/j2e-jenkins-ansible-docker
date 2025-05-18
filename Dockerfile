# Stage build    
FROM maven:3.9.9 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package
#Stage run
FROM tomcat:9
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/app-j2e