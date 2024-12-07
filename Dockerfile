# Используем базовый образ OpenJDK 17
FROM openjdk:17-jdk-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем необходимые утилиты: Git и Maven
RUN apt-get update && \
    apt-get install -y git maven && \
    rm -rf /var/lib/apt/lists/*

# Клонируем репозиторий
ARG REPO_URL=https://github.com/nervig/FreeCodeCampSeleniumJava.git
RUN git clone $REPO_URL .

# Скачиваем зависимости и собираем проект без тестов
RUN mvn clean install -DskipTests

# Контейнер готов для использования Jenkins
CMD ["tail", "-f", "/dev/null"]