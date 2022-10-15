apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: wordpress-ingress
  namespace: enviroment
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt"
spec:
  rules:
  - host: wordpress.enviroment.xxx.xxx.xxx.xxx.nip.io
    http:
      paths:
      - backend:
          serviceName: wordpress-svc
          servicePort: 80
  tls:
  - hosts:
    - wordpress.enviroment.xxx.xxx.xxx.xxx.nip.io
    secretName: ingress-wordpress-cert
