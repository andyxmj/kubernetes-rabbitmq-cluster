FROM centos
MAINTAINER andy xu andyxmj@gmail.com

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm \
	&& yum install -y erlang \
	&& rpm --import https://www.rabbitmq.com/rabbitmq-release-signing-key.asc \
	&& yum install -y https://github.com/rabbitmq/rabbitmq-server/releases/download/rabbitmq_v3_6_10/rabbitmq-server-3.6.10-1.el7.noarch.rpm \ 
	&& /usr/sbin/rabbitmq-plugins list <<<'y' \
	&& /usr/sbin/rabbitmq-plugins enable --offline rabbitmq_mqtt rabbitmq_stomp rabbitmq_management  rabbitmq_management_agent rabbitmq_management_visualiser rabbitmq_federation rabbitmq_federation_management sockjs<<<'y' \
	&& yum clean all && rm -rf /var/cache/yum/* && rm -rf /var/tmp/*

ADD rabbitmq.config /etc/rabbitmq/

RUN chmod u+rw /etc/rabbitmq/rabbitmq.config

ADD erlang.cookie /var/lib/rabbitmq/.erlang.cookie

RUN chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie

RUN chmod 400 /var/lib/rabbitmq/.erlang.cookie
ADD startrabbit.sh /opt/rabbit/
RUN chmod a+x /opt/rabbit/startrabbit.sh
EXPOSE 4369 5671 5672 25672 9100 9101 9102 9103 9104 9105
CMD /opt/rabbit/startrabbit.sh
