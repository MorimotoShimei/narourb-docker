# Narou.rb
FROM morimotoshimei/buildenv:ruby3.0-debian AS build

ENV DEBIAN_FRONTEND noninteractive

## AozoraEpub3 https://github.com/kyukyunyorituryo/AozoraEpub3/
WORKDIR /tmp
RUN curl -fsSLO https://github.com/kyukyunyorituryo/AozoraEpub3/releases/download/1.1.0b55Q/AozoraEpub3-1.1.0b55Q.zip
RUN unzip -qq AozoraEpub3-1.1.0b55Q.zip
RUN mv ./AozoraEpub3-1.1.0b55Q /opt/aozoraepub3/

## Narou.rb https://github.com/whiteleaf7/narou
WORKDIR /tmp
RUN gem install narou -v 3.8.0 --no-document

WORKDIR /build
RUN cp --archive --parents --no-dereference /opt/aozoraepub3 /build
RUN cp --archive --parents --no-dereference /usr/local/bundle /build
RUN cp --archive --parents --no-dereference /usr/local/lib/ruby /build

RUN rm -rf /tmp/* /var/cache/apk/*


FROM ruby:3.0.1-slim-buster
LABEL maintainer "morimotoshimei <morimoto.shimei@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV LD_LIBRARY_PATH /usr/i686-linux-gnu/lib

COPY ./services.sh /usr/local/bin/services.sh

COPY --from=build /build /

RUN set -eux && \
	mkdir /usr/share/man/man1/ && \
	apt-get update -qq && \
	apt-get install -y --no-install-recommends \
		openjdk-11-jre \
		binfmt-support \
		libc6-i386-cross \
		qemu \
		qemu-user-static \
		tzdata && \
	\
	ln -s /usr/i686-linux-gnu/lib/ld.linux.so.2 /lib/ld.linux.so.2 && \
	echo "none /proc/sys/fs/binfmt_misc binfmt_misc defaults 0 0" | tee /etc/fstab && \
	\
	mkdir .narousetting  && \
	narou init -p /opt/aozoraepub3 -l 1.8 && \
	\
	# cleaning
	apt-get clean && \
	rm -rf /tmp/* /var/lib/apt/lists/* && \
	\
	chmod 755 /usr/local/bin/services.sh


WORKDIR /var/opt/narou

EXPOSE 33000
EXPOSE 33001
VOLUME /var/opt/narou
ENTRYPOINT ["/usr/local/bin/services.sh"]
CMD ["narou", "web", "-np", "33000"]
