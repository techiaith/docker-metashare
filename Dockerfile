#
# Copyright 2016 Prifysgol Bangor University
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
FROM buildpack-deps:trusty

#RUN rm /bin/sh && ln -s /bin/bash /bin/sh
#RUN apt-get update && apt-get install -q -y software-properties-common
#RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe"
RUN apt-get update && apt-get install -q -y wget build-essential python openjdk-7-jre postgresql \
	libpq-dev python-dev python-pip lighttpd

COMMIT="9645dcdf33a7089f00ed256f37e8d93e3ea26294"
RUN wget --quiet "https://github.com/metashare/META-SHARE/archive/$COMMIT.tar.gz"
RUN tar -zxvf "$COMMIT.tar.gz"
RUN rm "$COMMIT.tar.gz"
RUN mv "META-SHARE-$COMMIT" "META-SHARE-3.0.2"

WORKDIR /META-SHARE-3.0.2

# there's a problem installing httplib2 from the requirements.txt (not on pypi). Install it manuyally first
RUN git config --global url."https://".insteadOf git://
RUN pip install https://httplib2.googlecode.com/files/httplib2-0.7.1.zip
RUN pip install -r requirements.txt

# make static files dir
RUN mkdir -p /var/www/html/metashare_static

# create postgres dbs
WORKDIR /
COPY createdb.sh createdb.sh
RUN bash createdb.sh

WORKDIR /META-SHARE-3.0.2/metashare
RUN mkdir -p /metashare_resources
RUN mkdir -p log
RUN chmod 775 log

COPY local_settings.py /META-SHARE-3.0.2/metashare/local_settings.py 

# add staticfiles app to metashare settings
RUN echo "INSTALLED_APPS += ('django.contrib.staticfiles',)" >> settings.py
COPY startup.sh /META-SHARE-3.0.2/metashare/startup.sh
RUN chmod a+x startup.sh

# lighttpd
RUN groupadd lighttpd
RUN useradd -g lighttpd -d /META-SHARE-3.0.2/metashare -s /sbin/nologin lighttpd
RUN usermod -a -G root lighttpd
COPY lighttpd.conf /META-SHARE-3.0.2/metashare/lighttpd.conf

RUN python manage.py collectstatic --noinput
# you may need to still run
RUN python manage.py syncdb --noinput
RUN python manage.py createsuperuserwithpassword --username=admin --password=admin --email=root@localhost

CMD /META-SHARE-3.0.2/metashare/startup.sh
EXPOSE 80
