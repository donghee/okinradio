FROM ruby:2.3.8-jessie

RUN gem install sinatra -v 1.4.8
RUN gem install public_suffix -v 4.0.7
RUN gem install thor -v 1.2.2
RUN gem install temple -v 0.8.2
RUN gem install haml
RUN gem install datamapper
RUN gem install dm-sqlite-adapter
#RUN gem install execjs -v 2.9.0
#RUN gem install coffee-script

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["ruby", "/radio/app.rb"]
