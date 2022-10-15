function nfs_provisioner {
  echo Install NFS nfs-provisioner
  cp -f nfs-provisioner/deployment.tpl nfs-provisioner/deployment.yaml
  sed -i "s/xxx.xxx.xxx.xxx/$nfs_ip/g" nfs-provisioner/deployment.yaml

  kubectl create ns provisioner
  kubectl apply -f nfs-provisioner/rbac.yaml
  kubectl apply -f nfs-provisioner/deployment.yaml
  kubectl apply -f nfs-provisioner/class.yaml
  # kubectl apply -f nfs-provisioner/pvc.test.yaml

  # kubectl get storageclass
  # kubectl get pvc

  # kubectl apply -f nfs-provisioner/pod.test.yaml
  # kubectl get pod -o wide
  # kubectl exec nginx -- ls /data/
}

function ingress {
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.2/deploy/static/provider/cloud/deploy.yaml
  kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml
  # kubectl apply -f ingress/cert-manager.yaml
}

function ingress_getip {
  external_ip="<pending>"
  while [ $external_ip == "<pending>" ]
  do
     echo Geting external ip ...
     external_ip=$(kubectl -n ingress-nginx get service/ingress-nginx-controller | tail -1|  awk '{print $4}')
     sleep 1
  done

  domain=$external_ip.nip.io

  echo external ip: $external_ip
  echo domain: $domain
  echo; echo
}

function prometheus {
  echo Installing prometheus stack
  namespace=monitoring
  kubectl create namespace $namespace
  kubectl -n $namespace create secret generic basic-auth --from-file=auth
  kubectl -n $namespace apply -f ingress/cert-manager.prometheus.yaml

  cp -f ingress/values.prometheus-stack.tpl values.prometheus-stack.yaml
  sed -i "s/xxx.xxx.xxx.xxx/$external_ip/g" values.prometheus-stack.yaml

  helm -n $namespace upgrade --install prometheus-stack --create-namespace -f values.prometheus-stack.yaml kube-prometheus-stack

  echo https://grafana.$domain
  echo https://prometheus.$domain
  echo https://alertmanager.$domain
}

function efk {
  echo Installing EFK stack

  namespace=logging
  kubectl create namespace $namespace
  kubectl -n $namespace create secret generic basic-auth --from-file=auth
  kubectl -n $namespace apply -f ingress/cert-manager.efk.yaml

  cp -f ingress/values.kibana.tpl values.kibana.yaml
  sed -i "s/xxx.xxx.xxx.xxx/$external_ip/g" values.kibana.yaml


  helm -n $namespace upgrade --install elastic -f values.es.yaml efk/elasticsearch
  helm -n $namespace upgrade --install kibana -f values.kibana.yaml efk/kibana
  helm -n $namespace upgrade --install fluent-bit -f values.fb.yaml efk/fluent-bit


  echo https://kibana.$domain
}

function mysql {
  helm secrets upgrade --install mysql --create-namespace -n mysql -f secrets.mysql.yaml mysql
}

function wordpress {
  namespace=wordpress
  kubectl -n $namespace apply -f ingress/cert-manager.wordpress.yaml
  cp -f ingress/ingress.wordpress.tpl wordpress/templates/ingress.yaml
  sed -i "s/xxx.xxx.xxx.xxx/$external_ip/g" wordpress/templates/ingress.yaml
  helm secrets upgrade --install wordpress --create-namespace -n $namespace -f secrets.wordpress.yaml wordpress
  echo; echo https://wordpress.$domain
}
