FROM alpine:3.1
MAINTAINER CenturyLink Labs <ctl-labs-futuretech@centurylink.com>
EXPOSE 9292

RUN apk update && apk add ruby-dev=2.1.7-r0 ca-certificates
RUN echo 'install: --no-document' >> /root/.gemrc
RUN gem install bundler

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install

RUN mkdir /app
WORKDIR /app
ADD . /app

CMD ["bundle","exec","rackup","-o","0.0.0.0"]
