# Narou.rb
FROM collelog/narou:3.8.0
LABEL maintainer "morimotoshimei <morimoto.shimei@gmail.com>"

RUN gem install rubygems-update --source http://rubygems.org/
RUN update_rubygems
RUN gem install narou -v 3.9.1 --no-document
