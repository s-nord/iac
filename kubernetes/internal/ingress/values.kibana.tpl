---
elasticsearchHosts: "http://elasticsearch-master:9200"

replicas: 1

# Extra environment variables to append to this nodeGroup
# This will be appended to the current 'env:' key. You can use any of the kubernetes env
# syntax here
extraEnvs:
  - name: "NODE_OPTIONS"
    value: "--max-old-space-size=1800"
#  - name: MY_ENVIRONMENT_VAR
#    value: the_value_goes_here

# Allows you to load environment variables from kubernetes secret or config map
envFrom: []
# - secretRef:
#     name: env-secret
# - configMapRef:
#     name: config-map

# A list of secrets and their paths to mount inside the pod
# This is useful for mounting certificates for security and for mounting
# the X-Pack license
secretMounts: []
#  - name: kibana-keystore
#    secretName: kibana-keystore
#    path: /usr/share/kibana/data/kibana.keystore
#    subPath: kibana.keystore # optional

hostAliases: []
#- ip: "127.0.0.1"
#  hostnames:
#  - "foo.local"
#  - "bar.local"

image: "docker.elastic.co/kibana/kibana"
imageTag: "7.17.3"
imagePullPolicy: "IfNotPresent"

# additionals labels
labels: {}

annotations: {}

podAnnotations: {}
# iam.amazonaws.com/role: es-cluster

resources:
  requests:
    cpu: "100m"
    memory: "1Gi"

protocol: http

serverHost: "0.0.0.0"

healthCheckPath: "/app/kibana"

# Allows you to add any config files in /usr/share/kibana/config/
# such as kibana.yml
kibanaConfig: {}
#   kibana.yml: |
#     key:
#       nestedkey: value

# If Pod Security Policy in use it may be required to specify security context as well as service account

podSecurityContext:
  fsGroup: 1000

securityContext:
  capabilities:
    drop:
      - ALL
  # readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 1000

serviceAccount: ""

# Whether or not to automount the service account token in the pod. Normally, Kibana does not need this
automountToken: true

# This is the PriorityClass settings as defined in
# https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass
priorityClassName: ""

httpPort: 5601

extraVolumes:
  []
  # - name: extras
  #   emptyDir: {}

extraVolumeMounts:
  []
  # - name: extras
  #   mountPath: /usr/share/extras
  #   readOnly: true
  #

extraContainers: []
# - name: dummy-init
#   image: busybox
#   command: ['echo', 'hey']

extraInitContainers: []
# - name: dummy-init
#   image: busybox
#   command: ['echo', 'hey']

updateStrategy:
  type: "Recreate"

service:
  type: ClusterIP
  loadBalancerIP: ""
  port: 5601
  nodePort: ""
  labels: {}
  annotations:
    {}
    # cloud.google.com/load-balancer-type: "Internal"
    # service.beta.kubernetes.io/aws-load-balancer-internal: 0.0.0.0/0
    # service.beta.kubernetes.io/azure-load-balancer-internal: "true"
    # service.beta.kubernetes.io/openstack-internal-load-balancer: "true"
    # service.beta.kubernetes.io/cce-load-balancer-internal-vpc: "true"
  loadBalancerSourceRanges:
    []
    # 0.0.0.0/0
  httpPortName: http

ingress:
  enabled: true
  className: "nginx"
  pathtype: ImplementationSpecific
  annotations:
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: basic-auth
    nginx.ingress.kubernetes.io/auth-realm: 'Authentication Required'
    # kubernetes.io/ingress.class: nginx
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: "letsencrypt"
  hosts:
    - host: kibana.xxx.xxx.xxx.xxx.nip.io
      paths:
        - path: /
  tls:
   - secretName: kibana-general-tls
     hosts:
       - kibana.xxx.xxx.xxx.xxx.nip.io

readinessProbe:
  failureThreshold: 3
  initialDelaySeconds: 10
  periodSeconds: 10
  successThreshold: 3
  timeoutSeconds: 5

imagePullSecrets: []
nodeSelector: {}
tolerations: []
affinity: {}

nameOverride: ""
fullnameOverride: ""

lifecycle:
  {}
  # preStop:
  #   exec:
  #     command: ["/bin/sh", "-c", "echo Hello from the postStart handler > /usr/share/message"]
  # postStart:
  #   exec:
  #     command: ["/bin/sh", "-c", "echo Hello from the postStart handler > /usr/share/message"]

# Deprecated - use only with versions < 6.6
elasticsearchURL: "" # "http://elasticsearch-master:9200"
