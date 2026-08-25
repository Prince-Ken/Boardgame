# ===== Build Stage =====
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
# rrr
# Copy pom.xml first to leverage Docker layer caching
COPY pom.xml .

# Pre-download dependencies (faster rebuilds)
RUN mvn -B -q -DskipTests dependency:go-offline

# Copy project source
COPY src ./src

# Build the JAR (skip tests for faster build)
RUN mvn clean package -DskipTests

# ===== Runtime Stage =====
FROM eclipse-temurin:17-jre-alpine

# Create non-root user
RUN addgroup -S appgroup && adduser -S -u 1001 -G appgroup appuser



WORKDIR /app

# Copy built jar from build stage
COPY --from=build /app/target/*.jar app.jar

RUN chown -R appuser:appgroup /app


USER appuser

# Expose app port
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
