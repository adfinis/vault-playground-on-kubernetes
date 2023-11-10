#!/usr/bin/env bash

# function that takes kubernetes ingress name and domain name and ands it to /etc/hosts

function add_ingress_to_hosts() {
    echo -e  "$(kubectl get ingress $1 -n$2 -o jsonpath='{.status.loadBalancer.ingress[0].ip}') $3" | sudo tee -a /etc/hosts
}




# backup the hosts file
mkdir -p backup
cp /etc/hosts backup/hosts

# clean up the hosts file
sudo sed -i '/### vault playground start ###/,/### vault playground end ###/d' /etc/hosts



echo -e "### vault playground start ###" | sudo tee -a /etc/hosts
echo -e "#the cleanup script will delete everything between this tags" | sudo tee -a /etc/hosts


add_ingress_to_hosts "vault-ui-ingress" "vault" "vault-ui.playground.lab"
add_ingress_to_hosts "vault-cli-ingress" "vault" "vault-cli.playground.lab"
add_ingress_to_hosts "prometheus-ingress" "$VAULT_K8S_NAMESPACE" "prometheus.playground.lab"
add_ingress_to_hosts "grafana-ingress" "$VAULT_K8S_NAMESPACE" "grafana.playground.lab"
add_ingress_to_hosts "openldap-stack-ha-ltb-passwd" "$VAULT_K8S_NAMESPACE" "ssl-ldap2.playground.lab"
add_ingress_to_hosts "openldap-stack-ha-phpldapadmin" "$VAULT_K8S_NAMESPACE" "phpldapadmin.playground.lab"
add_ingress_to_hosts "homer" "$VAULT_K8S_NAMESPACE" "explore.playground.lab"




echo -e "### vault playground end ###" | sudo tee -a /etc/hosts
