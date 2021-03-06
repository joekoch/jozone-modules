#!/bin/bash -xe
exec > >(tee /var/log/user-data.log | logger -t user-data -s) 2>&1
splunkasg=${splunkshcasgname}
ready=false
readycount=0
shcmem=""
for i in $(
  aws ec2 describe-instances --region us-east-1 --instance-ids \
    $(
      aws autoscaling describe-auto-scaling-instances --region us-east-1 --output text \
        --query "AutoScalingInstances[].[AutoScalingGroupName,InstanceId]" | grep -P "${splunkshcasgname}" | cut -f 2
    ) \
    --query "Reservations[].Instances[].PrivateDnsName" \
    --filters Name=instance-state-name,Values=running --output text
); do
  host="https://$i:8089"
  shcmem+="https://$i:8089,"
  ready="false"
  retry=0
  while [[ "$ready" == false && "$retry" != ${shc_init_check_retry_count} ]]; do
    echo "checking..."$host
    if (($(curl -sk $host/services/shcluster/config -u admin:gmntssplunk | grep -oP '(?<=shcluster_label">)[^<]+') == ${shclusterlabel})); then
      echo "host is ready"
      ready="true"
      ((readycount += 1))
    else
      sleep ${shc_init_check_retry_sleep_wait}
      ((retry += 1))
    fi
  done
done
if [[ "$readycount" == ${shcmembercount} ]]; then
  echo "setting shc captain...."
  shcmem=$${shcmem:0:-1}
  sudo -u splunk /data/gmnts/splunk/bin/splunk bootstrap shcluster-captain -servers_list $shcmem -auth admin:${splunkadminpass}
  sudo service splunk restart
else
  echo "node "$host" not ready..exiting..."
  exit 1
fi
