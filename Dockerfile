# Используем легковесный образ Alpine
FROM openjdk:17-alpine

# Устанавливаем зависимости для Maven
RUN apk add --no-cache \
    bash \
    curl \
    git \
    unzip \
    && curl -sL https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz | tar xz -C /opt \
    && ln -s /opt/apache-maven-3.8.6/bin/mvn /usr/bin/mvn

# Устанавливаем переменные окружения для Java и Maven
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV MAVEN_HOME=/opt/apache-maven-3.8.6
ENV PATH="${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${PATH}"

# Проверяем версии Java и Maven (для отладки)
RUN java -version
RUN mvn -version

# Устанавливаем Jenkins
RUN curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | tee /etc/apt/trusted.gpg.d/jenkins.asc
RUN sh -c 'echo deb http://pkg.jenkins.io/debian/ stable main > /etc/apt/sources.list.d/jenkins.list'
RUN apk update && apk add jenkins

# Открываем порты для Jenkins
EXPOSE 8080

# Команда запуска Jenkins
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
