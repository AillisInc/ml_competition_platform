FROM ruby:2.7.0
RUN apt-get update -qq && \    
    apt-get install -y build-essential libpq-dev && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g n && \
    n stable && \              
    npm install -g yarn && \
    gem pristine --all && \
    gem install bundler && \
    mkdir /app                 
WORKDIR /app
