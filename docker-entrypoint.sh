#!/bin/bash

set -e

: ${MOODLE_SITE_FULLNAME:=Moodle}
: ${MOODLE_SITE_SHORTNAME:=Moodle}
: ${MOODLE_SITE_LANG:=en}
: ${MOODLE_ADMIN_USER:=admin}
: ${MOODLE_ADMIN_PASS:=password}
: ${MOODLE_ADMIN_EMAIL:=admin@example.com}
: ${MOODLE_DB_TYPE:=mariadb}
: ${MOODLE_ENABLE_SSL:=false}
: ${MOODLE_UPDATE:=false}

if [ -z "$MOODLE_DB_HOST" ]; then
	if [ -n "$MYSQL_PORT_3306_TCP_ADDR" ]; then
		MOODLE_DB_HOST=$MYSQL_PORT_3306_TCP_ADDR
	elif [ -n "$POSTGRES_PORT_5432_TCP_ADDR" ]; then
		MOODLE_DB_TYPE=pgsql
		MOODLE_DB_HOST=$POSTGRES_PORT_5432_TCP_ADDR
	elif [ -n "$DB_PORT_3306_TCP_ADDR" ]; then
		MOODLE_DB_HOST=$DB_PORT_3306_TCP_ADDR
	elif [ -n "$DB_PORT_5432_TCP_ADDR" ]; then
		MOODLE_DB_TYPE=pgsql
		MOODLE_DB_HOST=$DB_PORT_5432_TCP_ADDR
	else
		echo >&2 'error: missing MOODLE_DB_HOST environment variable'
		echo >&2 '	Did you forget to --link your database?'
		exit 1
	fi
fi

if [ -z "$MOODLE_DB_USER" ]; then
	if [ "$MOODLE_DB_TYPE" = "mysql" -o "$MOODLE_DB_TYPE" = "mariadb" ]; then
		echo >&2 'info: missing MOODLE_DB_USER environment variable, defaulting to "root"'
		MOODLE_DB_USER=root
	elif [ "$MOODLE_DB_TYPE" = "pgsql" ]; then
		echo >&2 'info: missing MOODLE_DB_USER environment variable, defaulting to "postgres"'
		MOODLE_DB_USER=postgres
	else
		echo >&2 'error: missing required MOODLE_DB_USER environment variable'
		exit 1
	fi
fi

if [ -z "$MOODLE_DB_PASSWORD" ]; then
	if [ -n "$MYSQL_ENV_MYSQL_ROOT_PASSWORD" ]; then
		MOODLE_DB_PASSWORD=$MYSQL_ENV_MYSQL_ROOT_PASSWORD
	elif [ -n "$POSTGRES_ENV_POSTGRES_PASSWORD" ]; then
		MOODLE_DB_PASSWORD=$POSTGRES_ENV_POSTGRES_PASSWORD
	elif [ -n "$DB_ENV_MYSQL_ROOT_PASSWORD" ]; then
		MOODLE_DB_PASSWORD=$DB_ENV_MYSQL_ROOT_PASSWORD
	elif [ -n "$DB_ENV_POSTGRES_PASSWORD" ]; then
		MOODLE_DB_PASSWORD=$DB_ENV_POSTGRES_PASSWORD
	else
		echo >&2 'error: missing required MOODLE_DB_PASSWORD environment variable'
		echo >&2 '	Did you forget to -e MOODLE_DB_PASSWORD=... ?'
		echo >&2
		echo >&2 '	(Also of interest might be MOODLE_DB_USER and MOODLE_DB_NAME)'
		exit 1
	fi
fi

: ${MOODLE_DB_NAME:=moodle}

if [ -z "$MOODLE_DB_PORT" ]; then
	if [ -n "$MYSQL_PORT_3306_TCP_PORT" ]; then
		MOODLE_DB_PORT=$MYSQL_PORT_3306_TCP_PORT
	elif [ -n "$POSTGRES_PORT_5432_TCP_PORT" ]; then
		MOODLE_DB_PORT=$POSTGRES_PORT_5432_TCP_PORT
	elif [ -n "$DB_PORT_3306_TCP_PORT" ]; then
		MOODLE_DB_PORT=$DB_PORT_3306_TCP_PORT
	elif [ -n "$DB_PORT_5432_TCP_PORT" ]; then
		MOODLE_DB_PORT=$DB_PORT_5432_TCP_PORT
	elif [ "$MOODLE_DB_TYPE" = "mysql" -o "$MOODLE_DB_TYPE" = "mariadb" ]; then
		MOODLE_DB_PORT="3306"
	elif [ "$MOODLE_DB_TYPE" = "pgsql" ]; then
		MOODLE_DB_PORT="5432"
	fi
fi

# Wait for the DB to come up
while [ `/bin/nc -w 1 $MOODLE_DB_HOST $MOODLE_DB_PORT < /dev/null > /dev/null; echo $?` != 0 ]; do
    echo "Waiting for $MOODLE_DB_TYPE database to come up at $MOODLE_DB_HOST:$MOODLE_DB_PORT..."
    sleep 1
done
echo "Database is up and running."

export MOODLE_DB_TYPE MOODLE_DB_HOST MOODLE_DB_USER MOODLE_DB_PASSWORD MOODLE_DB_NAME

TERM=dumb php -- <<'EOPHP'
<?php
// database might not exist, so let's try creating it (just to be safe)

if (getenv('MOODLE_DB_TYPE') == 'mysql' || getenv('MOODLE_DB_TYPE') == 'mariadb') {

    $mysql = new mysqli(getenv('MOODLE_DB_HOST'), getenv('MOODLE_DB_USER'), getenv('MOODLE_DB_PASSWORD'), '', (int)getenv('MOODLE_DB_PORT'));

    if ($mysql->connect_error) {
        file_put_contents('php://stderr', 'MySQL Connection Error: (' . $mysql->connect_errno . ') ' . $mysql->connect_error . "\n");
        exit(1);
    }

    if (!$mysql->query('CREATE DATABASE IF NOT EXISTS `' . $mysql->real_escape_string(getenv('MOODLE_DB_NAME')) . '`')) {
        file_put_contents('php://stderr', 'MySQL "CREATE DATABASE" Error: ' . $mysql->error . "\n");
    }

    $mysql->close();
}
EOPHP

cd /var/www/html

: ${MOODLE_SHARED:=/moodledata}
if [ ! -d "$MOODLE_SHARED" ]; then
    echo "Created $MOODLE_SHARED directory."
    mkdir -p $MOODLE_SHARED
fi
#mkdir -p "$MOODLE_SHARED/images"
#
## If the images directory only contains a README, then link it to
## $MOODLE_SHARED/images, creating the shared directory if necessary
#if [ "$(ls images)" = "README" -a ! -L images ]; then
#    rm -fr images
#    ln -s "$MOODLE_SHARED/images" images
#fi
#
## If an extensions folder exists inside the shared directory, as long as
## /var/www/html/extensions is not already a symbolic link, then replace it
#if [ -d "$MOODLE_SHARED/extensions" -a ! -h /var/www/html/extensions ]; then
#    echo >&2 "Found 'extensions' folder in data volume, creating symbolic link."
#    rm -rf /var/www/html/extensions
#    ln -s "$MOODLE_SHARED/extensions" /var/www/html/extensions
#fi
#
## If a skins folder exists inside the shared directory, as long as
## /var/www/html/skins is not already a symbolic link, then replace it
#if [ -d "$MOODLE_SHARED/skins" -a ! -h /var/www/html/skins ]; then
#    echo >&2 "Found 'skins' folder in data volume, creating symbolic link."
#    rm -rf /var/www/html/skins
#    ln -s "$MOODLE_SHARED/skins" /var/www/html/skins
#fi
#
## If a vendor folder exists inside the shared directory, as long as
## /var/www/html/vendor is not already a symbolic link, then replace it
#if [ -d "$MOODLE_SHARED/vendor" -a ! -h /var/www/html/vendor ]; then
#    echo >&2 "Found 'vendor' folder in data volume, creating symbolic link."
#    rm -rf /var/www/html/vendor
#    ln -s "$MOODLE_SHARED/vendor" /var/www/html/vendor
#fi

# Attempt to enable SSL support if explicitly requested
if [ $MOODLE_ENABLE_SSL = true ]; then
    if [ ! -f $MOODLE_SHARED/ssl.key -o ! -f $MOODLE_SHARED/ssl.crt -o ! -f $MOODLE_SHARED/ssl.bundle.crt ]; then
        echo >&2 'error: Detected MOODLE_ENABLE_SSL flag but found no data volume';
        echo >&2 '	Did you forget to mount the volume with -v?'
        exit 1
    fi
    echo >&2 'info: enabling ssl'
    a2enmod ssl

    cp "$MOODLE_SHARED/ssl.key" /etc/apache2/ssl.key
    cp "$MOODLE_SHARED/ssl.crt" /etc/apache2/ssl.crt
    cp "$MOODLE_SHARED/ssl.bundle.crt" /etc/apache2/ssl.bundle.crt
elif [ -e "/etc/apache2/mods-enabled/ssl.load" ]; then
    echo >&2 'warning: disabling ssl'
    a2dismod ssl
fi

# Install database if installed file doesn't exist
if [ ! -e "$MOODLE_SHARED/installed" -a ! -f "$MOODLE_SHARED/install.lock" ]; then
    echo "Moodle database is not initialized. Initializing..."
    touch $MOODLE_SHARED/install.lock
    sudo -E -u www-data php admin/cli/install_database.php \
        --agree-license \
        --lang "$MOODLE_SITE_LANG" \
        --adminuser=$MOODLE_ADMIN_USER \
        --adminpass=$MOODLE_ADMIN_PASS \
        --adminemail=$MOODLE_ADMIN_EMAIL \
        --fullname="$MOODLE_SITE_FULLNAME" \
        --shortname="$MOODLE_SITE_SHORTNAME"
    if [ -n $SMTP_HOST ]; then
        sudo -E -u www-data php admin/cli/cfg.php --name=smtphosts --set=$SMTP_HOST
    fi
    if [ -n $SMTP_USER ]; then
        sudo -E -u www-data php admin/cli/cfg.php --name=smtpuser --set=$SMTP_USER
    fi
    if [ -n $SMTP_PASS ]; then
        sudo -E -u www-data php admin/cli/cfg.php --name=smtppass --set=$SMTP_PASS
    fi
    if [ -n $SMTP_SECURITY ]; then
        sudo -E -u www-data php admin/cli/cfg.php --name=smtpsecure --set=$SMTP_SECURITY
    fi
    if [ -n $SMTP_AUTH_TYPE ]; then
        sudo -E -u www-data php admin/cli/cfg.php --name=smtpauthtype --set=$SMTP_AUTH_TYPE
    fi
    if [ -n $MOODLE_NOREPLY_ADDRESS ]; then
        sudo -E -u www-data php admin/cli/cfg.php --name=noreplyaddress --set=$MOODLE_NOREPLY_ADDRESS
    fi

    touch $MOODLE_SHARED/installed
    rm $MOODLE_SHARED/install.lock
    echo "Done."
fi

# Install extensions
#if [[ $MOODLE_EXTENSIONS ]]; then
#    echo "<?php" > CustomExtensions.php
#    IFS="," read -ra exts <<< "$MOODLE_EXTENSIONS"
#    for i in "${exts[@]}"; do
#        if [[ -f /var/www/html/extensions/$i/extension.json ]]; then
#            echo "wfLoadExtension('$i');" >> CustomExtensions.php
#        fi
#    done
#fi

# If LocalSettings.php exists, then attempt to run the update.php maintenance
# script. If already up to date, it won't do anything, otherwise it will
# migrate the database if necessary on container startup. It also will
# verify the database connection is working.
if [ "$MOODLE_UPDATE" = 'true' -a ! -f "$MOODLE_SHARED/update.lock" ]; then
    echo "Updating Moodle..."
    touch $MOODLE_SHARED/update.lock
    sudo -E -u www-data /usr/local/bin/php admin/cli/maintenance.php --enable
    sudo -E -u www-data /usr/local/bin/php admin/cli/upgrade.php
    sudo -E -u www-data /usr/local/bin/php admin/cli/maintenance.php --disable
    rm $MOODLE_SHARED/update.lock
    echo "Done."
fi

# Run additional init scripts
DIR=/docker-entrypoint.d

if [[ -d "$DIR"  ]]
then
    /bin/run-parts --verbose "$DIR"
fi

exec "$@"
