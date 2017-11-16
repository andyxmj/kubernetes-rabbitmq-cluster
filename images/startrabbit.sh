#!/bin/bash

change_default_user() {
	
	if [ -z $RABBITMQ_DEFAULT_USER ] && [ -z $RABBITMQ_DEFAULT_PASS ]; then
		echo "Maintaining default 'guest' user"
	else 
		echo "Removing 'guest' user and adding ${RABBITMQ_DEFAULT_USER}"
		rabbitmqctl delete_user guest
		rabbitmqctl add_user $RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS
		rabbitmqctl set_user_tags $RABBITMQ_DEFAULT_USER administrator
		rabbitmqctl set_permissions -p $RABBITMQ_DEFAULT_VHOST $RABBITMQ_DEFAULT_USER ".*" ".*" ".*"
	fi
}

add_default_vhost() {
	if [ -z $RABBITMQ_DEFAULT_VHOST ] || [ $RABBITMQ_DEFAULT_VHOST == "/" ]; then
		echo "using defalut vhost /"
		RABBITMQ_DEFAULT_VHOST=/
	else
		rabbitmqctl add_vhost $RABBITMQ_DEFAULT_VHOST
	fi
}

change_mod_mnesia() {
	if [ -d "/var/lib/rabbitmq/mnesia" ]; then
		echo "changing mode[/var/lib/rabbitmq/mnesia] to 777."
		chmod 777 -R /var/lib/rabbitmq/mnesia
	fi
}

if [ -z "$RABBITMQ_HOSTNAME" ]; then
	HOSTNAME=`env hostname`
else
	HOSTNAME=$RABBITMQ_HOSTNAME
fi

change_mod_mnesia

if [ -z "$CLUSTERED" ]; then
	# if not clustered then start it normally as if it is a single server
	/usr/sbin/rabbitmq-server &
	rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@$HOSTNAME.pid
	add_default_vhost
	change_default_user
	tail -f /var/log/rabbitmq/rabbit\@$HOSTNAME.log
else
	if [ -z "$CLUSTER_WITH" ]; then
		# If clustered, but cluster with is not specified then again start normally, could be the first server in the
		# cluster
		/usr/sbin/rabbitmq-server&
		rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@$HOSTNAME.pid
		add_default_vhost
		change_default_user
		tail -f /var/log/rabbitmq/rabbit\@$HOSTNAME.log
	else
		/usr/sbin/rabbitmq-server &
		rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@$HOSTNAME.pid
		add_default_vhost
		change_default_user
		rabbitmqctl stop_app
		if [ -z "$RAM_NODE" ]; then
			rabbitmqctl join_cluster rabbit@$CLUSTER_WITH
		else
			rabbitmqctl join_cluster --ram rabbit@$CLUSTER_WITH
		fi
		rabbitmqctl start_app
                
		# Tail to keep the a foreground process active..
		tail -f /var/log/rabbitmq/rabbit\@$HOSTNAME.log
	fi
fi


