#!/bin/bash

AMP_CONF=/etc/amportal.conf
ODBC_INI=/etc/odbc.ini
ASTERISK_CONF=/etc/asterisk/asterisk.conf
FREEPBX_CONF_PATH=/etc/freepbx.conf
FILES_DIR=$PWD/installlib/files
SQL_DIR=$PWD/installlib/SQL
MODULE_DIR=$PWD/amp_conf/htdocs/admin/modules
UPGRADE_DIR=$PWD/upgrades

DBENGINE=mysql
DBNAME=asterisk
CDRDBNAME=asteriskcdrdb
DBUSER=root
DBPASS=
USER=asterisk
GROUP=asterisk
DEVLINKS=n
WEBROOT=/var/www/html
ASTETCDIR=/etc/asterisk
ASTMODDIR=/usr/lib/asterisk/modules
ASTVARLIBDIR=/var/lib/asterisk
ASTAGIDIR=/var/lib/asterisk/agi-bin
ASTSPOOLDIR=/var/spool/asterisk
ASTRUNDIR=/var/run/asterisk
ASTLOGDIR=/var/log/asterisk
AMPBIN=/var/lib/asterisk/bin
AMPSBIN=/usr/sbin
AMPCGIBIN=/var/www/cgi-bin
AMPPLAYBACK=/var/lib/asterisk/playback
ROOTDB=n
DBROOT=n
FORCE=n
VERSION=13.0.194.3


help() {
  echo -e "install.sh [options]
  -e <dbengine>      Database engine (default: mysql)
  -n <dbname>        Database name (default: asterisk)
  -c <cdrdbname>     CDR Database name (default: asteriskcdrdb)
  -d <dbuser>        Database username (default: root)
  -p <dbpass>        Database password (default: '')
  -u <user>          File owner user (default: asterisk)
  -g <group>         File owner group (default: asterisk)
  -l                 Make links to files in the source directory instead of copying (developer option)
  -w <webroot>       Filesystem location from which FreePBX files will be served (default: /var/www/html)
  -t <astetcdir>     Filesystem location from which Asterisk configuration files will be served (default: /etc/asterisk)
  -m <astmoddir>     Filesystem location for Asterisk modules (default: /usr/lib/asterisk/modules)
  -v <astvarlibdir>  Filesystem location for Asterisk lib files (default: /var/lib/asterisk)
  -a <astagidir>     Filesystem location for Asterisk agi files (default: /var/lib/asterisk/agi-bin)
  -s <astspooldir>   Location of the Asterisk spool directory (default: /var/spool/asterisk)
  -r <astrundir>     Location of the Asterisk run directory (default: /var/run/asterisk)
  -v <astlogdir>     Location of the Asterisk log files (default: /var/log/asterisk)
  -b <ampbin>        Location of the FreePBX command line scripts (default: /var/lib/asterisk/bin)
  -k <ampsbin>       Location of the FreePBX (root) command line scripts (default: /usr/sbin)
  -i <ampcgibin>     Location of the Apache cgi-bin executables (default: /var/www/cgi-bin)
  -y <ampplayback>   Directory for FreePBX html5 playback files (default: /var/lib/asterisk/playback)
  -o                 Database Root Based Install. Will create the database user and password automatically along with the databases
  -f                 Force an install. Rewriting all databases with default information" 1>&2
  exit
}

while getopts "e:n:c:d:p:u:g:lw:t:m:v:a:s:r:v:b:k:i:y:of" opt; do
  case $opt in
    e)
      DBENGINE=$OPTARG
      ;;
    n)
      DBNAME=$OPTARG
      ;;
    c)
      CDRDBNAME=$OPTARG
      ;;
    d)
      DBUSER=$OPTARG
      ;;
    p)
      DBPASS=$OPTARG
      ;;
    u)
      USER=$OPTARG
      ;;
    g)
      GROUP=$OPTARG
      ;;
    l)
      DEVLINKS=y
      ;;
    w)
      WEBROOT=$OPTARG
      ;;
    t)
      ASTETCDIR=$OPTARG
      ;;
    m)
      ASTMODDIR=$OPTARG
      ;;
    v)
      ASTVARLIBDIR=$OPTARG
      ;;
    a)
      ASTAGIDIR=$OPTARG
      ;;
    s)
      ASTSPOOLDIR=$OPTARG
      ;;
    r)
      ASTRUNDIR=$OPTARG
      ;;
    v)
      ASTLOGDIR=$OPTARG
      ;;
    b)
      AMPBIN=$OPTARG
      ;;
    k)
      AMPSBIN=$OPTARG
      ;;
    i)
      AMPCGIBIN=$OPTARG
      ;;
    y)
      AMPPLAYBACK=$OPTARG
      ;;
    o)
      ROOTDB=y
      ;;
    f)
      FORCE=y
      ;;
    h)
      help
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      help
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ "$ROOTDB" == "y" -o "$DBUSER" == "root" ]; then
  DBROOT=y
fi

echo "AMP_CONF : $AMP_CONF"
echo "ODBC_INI : $ODBC_INI"
echo "ASTERISK_CONF : $ASTERISK_CONF"
echo "FREEPBX_CONF_PATH : $FREEPBX_CONF_PATH"
echo "FILES_DIR : $FILES_DIR"
echo "SQL_DIR : $SQL_DIR"
echo "MODULE_DIR : $MODULE_DIR"
echo "UPGRADE_DIR : $UPGRADE_DIR"

echo "DBENGINE : $DBENGINE"
echo "DBNAME : $DBNAME"
echo "CDRDBNAME : $CDRDBNAME"
echo "DBUSER : $DBUSER"
echo "DBPASS : $DBPASS"
echo "USER : $USER"
echo "GROUP : $GROUP"
echo "DEVLINKS : $DEVLINKS"
echo "WEBROOT : $WEBROOT"
echo "ASTETCDIR : $ASTETCDIR"
echo "ASTMODDIR : $ASTMODDIR"
echo "ASTVARLIBDIR : $ASTVARLIBDIR"
echo "ASTAGIDIR : $ASTAGIDIR"
echo "ASTSPOOLDIR : $ASTSPOOLDIR"
echo "ASTRUNDIR : $ASTRUNDIR"
echo "ASTLOGDIR : $ASTLOGDIR"
echo "AMPBIN : $AMPBIN"
echo "AMPSBIN : $AMPSBIN"
echo "AMPCGIBIN : $AMPCGIBIN"
echo "AMPPLAYBACK : $AMPPLAYBACK"
echo "ROOTDB : $ROOTDB"
echo "DBROOT : $DBROOT"
echo "FORCE : $FORCE"

# check if SELinux is enabled?

if [ ! -e $ASTERISK_CONF ]; then
  echo "No $ASTERISK_CONF file detected. Installing..."
  # read $FILES_DIR/asterisk.conf
  # Check if directories section is empty
  # if empty, exit script
else
  echo -e "Reading $ASTERISK_CONF..."
  # read $ASTERISK_CONF
  # Check if directories section is empty
  # if empty, exit script
  echo "Done"
fi

if [ ! -e $ASTERISK_CONF -o "$FORCE" == "y" ]; then
  # Write a new file in $ATERISK_CONF with all the values
  # from the command line
fi

# Check version of asterisk

if [[-e $FREEPBX_CONF_PATH -a !-e $AMP_CONF] -o [ !-e $FREEPBX_CONF_PATH -a -e $AMP_CONF]]; then
  echo "Error: Half-baked install previously detected."
  exit 1
fi

echo "Preliminary checks done. Starting FreePBX Installation"

if [ -e $WEBROOT/admin/bootstrap.php -a ]

# Do some checks to detect whether it is a new install

# Create $AMP_CONF contents

# copy $FILES_DIR/odbc.ini $ODBC_INI

# copy some values form $ASTERISK_CONF to $AMP_CONF

# Create new asterisk database
if [ ! -e $AST_DATABASE_FILE ]; then
  sqlite3 $AST_DATABASE_FILE < asterisk.sql
fi

# populate the database by running the $SQL_DIR/asterisk.sql file on it

# Create new CDR database
if [ ! -e $CDR_DATABASE_FILE ]; then
  sqlite3 $CDR_DATABASE_FILE < cdr.sql
fi

# populate the database by running the $SQL_DIR/cdr.sql file on it

# get version of Freepbx
# initialize settings of freepbx
# in the database, this is table "freepbx_settings"
# Use the settings that were given at install time

mkdir -m 0777 -p $WEBROOT
chown -R $USER:$GROUP $WEBROOT

# copy all files to the correct destination
cp -R $PWD/amp_conf/agi-bin/* $ASTAGIDIR
cp -R $PWD/amp_conf/astetc/* $ASTETCDIR
cp -R $PWD/amp_conf/bin/* $AMPBIN
cp -R $PWD/amp_conf/etc/init.d/* /etc/init.d/
cp -R $PWD/amp_conf/htdocs/* $WEBROOT
cp -R $PWD/amp_conf/moh/* /var/lib/asterisk/moh

mkdir -p -m 0755 $AMPBIN
mkdir -p -m 0755 $AMPSBIN

# Create symlinks
ln -rs $AMPBIN/fwconsole $AMPSBIN/fwconsole
ln -rs $AMPBIN/amportal $AMPSBIN/amportal

# set permissions
chmod 0755 $AMPBIN/freepbx_engine
chmod 0755 $AMPBIN/freepbx_setting
chmod 0755 $AMPBIN/fwconsole
chmod 0755 $AMPBIN/gen_amp_conf
chmod 0755 $AMPBIN/retrieve_conf
chmod 0755 $AMPSBIN/amportal
chmod 0755 $AMPSBIN/fwconsole

# create additional dirs
mkdir -m 0777 -p $WEBROOT/admin/modules/_cache
mkdir -m 0777 -p $WEBROOT/admin/modules/framework
mkdir -m 0755 -p $ASTSPOOLDIR/voicemail/device
mkdir -m 0766 -p $ASTSPOOLDIR/fax
mkdir -m 0766 -p $ASTSPOOLDIR/monitor

# Copy framework files
cp $PWD/module.xml $AMPWEBROOT/admin/modules/framework/
cp $PWD/module.sig $AMPWEBROOT/admin/modules/framework/
cp $PWD/install.php $AMPWEBROOT/admin/modules/framework/
# cp $PWD/LICENSE $AMPWEBROOT/admin/modules/framework/
# cp $PWD/README.md $AMPWEBROOT/admin/modules/framework/

# copy voicemail.conf
cp $ASTETCDIR/voicemail.conf.template $ASTETCDIR/voicemail.conf

# replace with sed some variables in files $ASTETCDIR/manager.conf $ASTETCDIR/cdr_adaptive_odbc.conf and $ODBC_INI
# 'AMPMGRUSER','AMPMGRPASS','CDRDBNAME','AMPDBUSER','AMPDBPASS'

# Create missing #include files.
FILES=confbridge_custom.conf \
iax_custom_post.conf \
iax_custom.conf \
sip_notify_custom.conf \
logger_general_custom.conf \
udptl_custom.conf \
queues_custom.conf \
pjsip.aor_custom.conf \
sip_general_custom.conf \
pjsip.transports_custom_post.conf \
pjsip.auth_custom_post.conf \
extensions_custom.conf \
sip_nat.conf \
extensions_override_freepbx.conf \
pjsip.registration_custom.conf \
xmpp_general_custom.conf \
meetme_general_additional.conf \
manager_custom.conf \
pjsip.endpoint_custom.conf \
queues_post_custom.conf \
xmpp_custom.conf \
pjsip.registration_custom_post.conf \
pjsip.aor_custom_post.conf \
ari.conf \
manager_additional.conf \
pjsip_custom.conf \
res_odbc_custom.conf \
pjsip_custom_post.conf \
pjsip.endpoint_custom_post.conf \
logger_logfiles_custom.conf \
cel_general_custom.conf \
sip_custom.conf \
queues_custom_general.conf \
sip_registrations_custom.conf \
musiconhold_custom.conf \
cel_odbc_custom.conf \
http_custom.conf \
features_applicationmap_custom.conf \
globals_custom.conf \
features_featuremap_custom.conf \
pjsip.transports_custom.conf \
pjsip.identify_custom_post.conf \
iax_general_custom.conf \
pjsip.auth_custom.conf \
rtp_custom.conf \
meetme_general_custom.conf \
sip_custom_post.conf \
iax_registrations_custom.conf \
pjsip.identify_custom.conf \
features_general_custom.conf \
cel_custom_post.conf \
motif_custom.conf \
cdr.conf

for file in $FILES
do
  if [ ! -e /etc/asterisk/$file ]; then
    touch /etc/asterisk/$file
  fi
done

# run through upgrades?

#set version of freepbx in database:
# UPDATE admin SET value = '$VERSION' WHERE variable = 'version'

# write $AMP_CONF
# write FREEPBX_CONF_PATH

# at runtime, run: 
# fwconsole chown
# fwconsole ma install framework
# run pgp php script
# fwconsole ma install core
# fwconsole ma installlocal
# fwconsole chown
# fwconsole reload

# <?php
# namespace FreePBX\Install;
# 
# // GPG setup - trustFreePBX();
# $output->write("Trusting FreePBX...");
# try {
#   \FreePBX::GPG()->trustFreePBX();
# } catch(\Exception $e) {
#   $output->writeln("<error>Error!</error>");
#   $output->writeln("<error>Error while trusting FreePBX: ".$e->getMessage()."</error>");
#   exit(1);
# }
# 
# // Make sure we have the latest keys, if this install is out of date.
# \FreePBX::GPG()->refreshKeys();
# 
# $output->writeln("Trusted");
# 
# ?>
