FROM odoo:10.0 
MAINTAINER BradooTech <virgilio.santos@bradootech.com>

USER root

RUN set -x; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential bzr bzrtools libjpeg-dev libffi-dev libldap2-dev ssh \
    libpq-dev libsasl2-dev libxml2-dev libxmlsec1-dev libxslt-dev git \
    python-dev zlib1g-dev libjpeg62-turbo-dev npm mercurial wget telnet

RUN set -x; \
    apt-get install -y --no-install-recommends \
    fontconfig ghostscript graphviz libfreetype6 libjpeg62-turbo \
    libx11-6 libxext6 libxrender1 locales node-clean-css nodejs \
    poppler-utils python-cffi python-gdata python-libxml2 \
    python-libxslt1 python-ofxparse python-openssl \
    python-simplejson python-unittest2 python-vatnumber \
    python-webdav python-zsi xfonts-75dpi xfonts-base && \
	npm install -g less less-plugin-clean-css && \
	ln -sf /usr/bin/nodejs /usr/bin/node && \
	apt-get clean

RUN locale-gen pt_BR.UTF-8 && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    set -x; \
    dpkg-reconfigure locales

#Install fonts
ADD fonts/c39hrp24dhtt.ttf /usr/share/fonts/c39hrp24dhtt.ttf
RUN chmod a+r /usr/share/fonts/c39hrp24dhtt.ttf && fc-cache -f -v

ADD requirements.txt /requirements.txt

RUN pip install --upgrade pip && \
    pip install flake8 && \
    pip install pgcli && \
    pip install -r /requirements.txt

RUN rm /requirements.txt -f
RUN usermod -u 1000 odoo
RUN groupmod -g 1000 odoo
RUN usermod -d /home/odoo odoo
WORKDIR /home/odoo
RUN chown -R odoo:odoo /home/odoo

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

USER odoo
RUN git config --global user.email "virgilio.santos@bradootech.com" &&\
    git config --global user.name "Virgilio Santos"
