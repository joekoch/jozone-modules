#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo -u splunk /data/gmnts/splunk/bin/splunk edit licenser-localslave -master_uri 'https://${license_master_hostname}:${splunk_mgmt_port}' -auth admin:${splunkadminpass}
sudo -u splunk echo -e "[general]\nserverName = "$(curl http://169.254.169.254/latest/meta-data/local-hostname)"-deployer" > /data/gmnts/splunk/etc/system/local/server.conf
sudo -u splunk echo -e  "[shclustering]\npass4SymmKey = ${shclusterkey}\nshcluster_label = ${shclusterlabel}" >> /data/gmnts/splunk/etc/system/local/server.conf
service splunk restart