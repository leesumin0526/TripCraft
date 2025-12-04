## Stage 1: Build (Code를 jar로 만드는 단계)
# java 17 JDK가 있는 이미지로 시작 (gradle 이미지를 썼더니 버전 충돌이 나서)
FROM eclipse-temurin:17-jdk AS builder

# 도커 안에서 /app 폴더를 작업 공간으로 사용
WORKDIR /app

# Build에 필요한 최소한의 의존성 설정 파일들만 복사

# gradlew: 프로젝트에서 사용하는 Gradle 실행기
# gradle/: gradle-wrapper.properties 등 “어떤 Gradle 버전을 사용할지” 적힌 파일
# build.gradle, settings.gradle: 의존성 목록을 가진 설정 파일
COPY gradlew ./
COPY gradle gradle
COPY build.gradle settings.gradle ./
RUN chmod +x ./gradlew

# build.gradle이 안 바뀌면 docker는 이 라인을 건너뛰어서, 속도가 빨라짐
RUN ./gradlew dependencies --no-daemon || return 0

# 소스 코드 복사
COPY src src

# 실제 jar 빌드 (테스트는 제외)
RUN ./gradlew clean bootJar -x test --no-daemon

## Stage 2: 실행용 이미지
# JRE만 포함된 가벼운 이미지
FROM eclipse-temurin:17-jre
WORKDIR /app

# 실행에 필요한 jar만 가져오기
COPY --from=builder /app/build/libs/*.jar app.jar

# 포트 열고 실행 명령
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]