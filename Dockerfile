FROM odoo:10.0 
MAINTAINER BradooTech <virgilio.santos@bradootech.com>

USER root

RUN sh -c 'echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf'
RUN sh -c 'echo "Acquire::http::Pipeline-Depth 0;" >> /etc/apt/apt.conf'


RUN set -x; \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y build-essential bzr bzrtools fontconfig ghostscript \
	git graphviz libffi-dev libfreetype6 libjpeg62-turbo-dev libjpeg-dev \
	libjpeg62-turbo libldap2-dev libpq-dev libsasl2-dev libx11-6 libxext6 \
	libxml2-dev libxmlsec1-dev libxrender1 libxslt-dev locales mercurial \
	node-clean-css nodejs node-less npm poppler-utils python-cffi \
	python-dev python-gdata python-libxml2 python-libxslt1 python-ofxparse \
	python-openssl python-pip python-simplejson curl ssh \
	python-unittest2 python-vatnumber python-webdav python-zsi subversion \
	telnet vim wget xfonts-75dpi xfonts-base zlib1g-dev && \
	npm install -g less less-plugin-clean-css && \
	ln -sf /usr/bin/nodejs /usr/bin/node && \
	apt-get clean

# Install postgresql client 9.6
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN set -x; \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y postgresql-client-9.6 && \
    apt-get clean

RUN locale-gen pt_BR.UTF-8 && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    set -x; \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

#Install fonts
ADD stack/fonts/c39hrp24dhtt.ttf /usr/share/fonts/c39hrp24dhtt.ttf
RUN chmod a+r /usr/share/fonts/c39hrp24dhtt.ttf && fc-cache -f -v

ADD stack/requirements.txt /requirements.txt

RUN pip install --upgrade pip && \
    pip install flake8 && \
    pip install pgcli && \
    pip install psycogreen && \
    pip install -r /requirements.txt

RUN rm /requirements.txt -f

WORKDIR /home/odoo
RUN chown -R odoo:odoo /home/odoo

COPY stack/entrypoint /usr/local/bin/entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]

USER odoo
RUN git config --global user.email "virgilio.santos@bradootech.com" &&\
    git config --global user.name "Virgilio Santos (Bradoo)"
