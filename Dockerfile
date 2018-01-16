FROM ubuntu:17.10

RUN apt-get update  #asd
RUN apt-get install -y jq git curl sudo postgresql postgresql-contrib

#RUN sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.6/main/postgresql.conf
#ADD /docker/postgres-init.sh /etc/init.d/postgresql
#RUN chmod a+x /etc/init.d/postgresql
#RUN mkdir -p /usr/local/pgsql/data
#RUN chown -R postgres:postgres /usr/local/pgsql/

USER postgres
#WORKDIR /usr/lib/postgresql/9.6/bin/
#RUN ./initdb -D /usr/local/pgsql/data
RUN /usr/lib/postgresql/9.6/bin/pg_ctl -D /var/lib/postgresql/9.6/main status &2>/dev/null
RUN /usr/lib/postgresql/9.6/bin/pg_ctl -D /var/lib/postgresql/9.6/main start
RUN ls -al /var/lib/postgresql/9.6/main
USER root

#RUN /etc/init.d/postgresql start
#RUN /etc/init.d/postgresql restart
#RUN /etc/init.d/postgresql status
RUN ls -al /var/run/postgresql/ && dropdb "wut"
RUN npm -v
RUN useradd -m sidechain -s /bin/bash && adduser sidechain sudo
RUN chown -R sidechain:sidechain /home/sidechain
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ADD /docker/sudoers.txt /etc/sudoers
RUN chmod 440 /etc/sudoers
USER sidechain
ENV USER=sidechain
WORKDIR /home/sidechain
COPY . /home/sidechain/ark-deployment/
RUN sudo chown -R sidechain:sidechain .
RUN ls -al /
RUN ls -al /home
RUN ls -al /home/sidechain
RUN ls -al
#RUN sudo chown -R sidechain:$(id -gn sidechain) /home/sidechain/.config
WORKDIR /home/sidechain/ark-deployment
#RUN git clone https://github.com/alexbarnsley/ark-deployment.git && cd ark-deployment

# Install NodeJS & NPM
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash \
	&& . ~/.nvm/nvm.sh \
	&& nvm install 8.9.1 \
	&& nvm alias default 8.9.1 \
	&& nvm use default \
	&& echo -e 'yes\nyes\n' | ./sidechain.sh install-node --name AlexTest --database ark_alex --token ALEX --symbol AL --ip 192.168.0.22
	#&& ./sidechain.sh start-node --name AlexTest \
	#&& ./sidechain.sh install-explorer --name AlexTest --token ALEX --ip 192.168.0.22 --skip-deps \
	#&& ./sidechain.sh start-explorer --ip 192.168.0.22