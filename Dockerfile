# Narou.rb
FROM collelog/narou:3.8.0
LABEL maintainer "morimotoshimei <morimoto.shimei@gmail.com>"

RUN gem install rubygems-update --source http://rubygems.org/
RUN update_rubygems
RUN gem install narou -v 3.9.1 --no-document
COPY ./lib/command/convert.rb /usr/local/bundle/gems/narou-3.9.1/lib/command/
COPY ./lib/novelconverter.rb /usr/local/bundle/gems/narou-3.9.1/lib/
COPY ./webnovel/ncode.syosetu.com.yaml /usr/local/bundle/gems/narou-3.9.1/webnovel/
COPY ./webnovel/novel18.syosetu.com.yaml /usr/local/bundle/gems/narou-3.9.1/webnovel/
COPY ./webnovel/syosetu.org.yaml /usr/local/bundle/gems/narou-3.9.1/webnovel/
COPY ./webnovel/www.akatsuki-novels.com.yaml /usr/local/bundle/gems/narou-3.9.1/webnovel/
