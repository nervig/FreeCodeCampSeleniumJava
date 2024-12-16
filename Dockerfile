# Используем официальный образ Ubuntu как базовый
FROM ubuntu:20.04

# Устанавливаем зависимости для установки Java 17 и Maven
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget \
    unzip \
    curl \
    git \
    && apt-get clean

# Устанавливаем Maven
RUN wget -qO- https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz | tar xvz -C /opt
RUN ln -s /opt/apache-maven-3.8.6/bin/mvn /usr/bin/mvn

# Устанавливаем переменные окружения для Java и Maven
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV MAVEN_HOME=/opt/apache-maven-3.8.6
ENV PATH="${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${PATH}"

# Проверяем версии Java и Maven (для отладки)
RUN java -version
RUN mvn -version

# Устанавливаем Jenkins
RUN curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | tee /etc/apt/trusted.gpg.d/jenkins.asc
RUN sh -c 'echo deb http://pkg.jenkins.io/debian/ stable main > /etc/apt/sources.list.d/jenkins.list'
RUN apt-get update && apt-get install -y jenkins

# Открываем порты для Jenkins
EXPOSE 8080

# Настроим Jenkins в качестве службы, чтобы он запускался при старте контейнера
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
