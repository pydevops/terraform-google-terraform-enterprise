#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

yum install -y dnsmasq

# custom dnsmasq config for sabre
cat <<EOF > /etc/dnsmasq.d/sabre.conf 
domain-needed
bogus-priv
no-resolv
addn-hosts=/etc/sabre_hosts
# change to your domain
expand-hosts
domain=${domain_name}
# change to your upstream dns server
server=${upstream_dns_server}
server=8.8.8.8
server=8.8.4.4
EOF

# custom /etc/sabre_hosts
cat <<EOF  > /etc/sabre_hosts
${ip_address} git.${domain_name}
EOF

systemctl start dnsmasq