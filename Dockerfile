FROM ruby:2.5.3
RUN apt-get update -qq && \    
    apt-get install -y build-essential libpq-dev && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs && \  
    apt-get install -y mysql-client && \
    npm install -g n && \
    n stable && \              
    npm install -g yarn && \
    mkdir /app                 
WORKDIR /app
