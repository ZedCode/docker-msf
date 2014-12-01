# Metasploit Dockerized
#
# Version 0.1
FROM ubuntu:14.04
# Make sure repo is up to date
RUN apt-get update && apt-get upgrade -y
# Install metasploit related packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential zlib1g zlib1g-dev libxml2 libxml2-dev libxslt-dev locate libreadline6-dev libcurl4-openssl-dev git-core libssl-dev libyaml-dev openssl autoconf libtool ncurses-dev bison curl wget postgresql postgresql-contrib libpq-dev libapr1 libaprutil1 libsvn1 libpcap-dev libsqlite3-dev
# Add a non-root user for msf to run under
# but still give passwordless sudo for install of needed libraries
RUN useradd -d /home/mallory -ms /bin/bash mallory && adduser mallory sudo && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
RUN mkdir /msf && chown -R mallory:mallory /msf
USER mallory
# Change Ruby versions on the following line
RUN cd /home/mallory && gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 && curl -o rvm.sh -L get.rvm.io && cat rvm.sh | bash -s stable --autolibs=enabled --ruby=1.9.3 && echo "source /home/mallory/.rvm/scripts/rvm" >> /home/mallory/.bash_profile
# With out this, nothing Ruby related will work right
ENV PATH $PATH:/home/mallory/.rvm/rubies/default/bin
# metasploit requires bundler, so install it
RUN /home/mallory/.rvm/rubies/default/bin/gem install bundler
# Clone the latest main metasploit framework from github
RUN /usr/bin/git clone https://github.com/rapid7/metasploit-framework.git /msf && cd /msf && bundle install
USER root
# Change this to change the password, make sure to also change
# scripts/startUp.sh which writes it to the yml config.
RUN echo "create user msf_user password 'Pa55word'" > /var/lib/postgresql/create_user.sql && /etc/init.d/postgresql start && chown postgres:postgres /var/lib/postgresql/create_user.sql && sudo -u postgres psql --file=/var/lib/postgresql/create_user.sql && sudo -u postgres createdb --owner=msf_user msf_database
ADD ./scripts/startUp.sh /startUp.sh
ADD ./scripts/firstRun.sh /firstRun.sh
