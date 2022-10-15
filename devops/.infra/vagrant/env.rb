module Vars
    VM_BOX = "generic/ubuntu1804"
    VM_NAME =   ["proxy", "logging", "monitoring", "app", "cicd"]
    VM_ENABLE = ["0",     "1",       "0",          "1",    "1"]
    VM_MEMORY = [1024,     1596,      1024,         1024,  2048 ]
    VM_NUMBER = VM_NAME.count

    PROVISIONING = true # true or false
    HOSTS_PUBLIC = "export/hosts.public"
    HOSTS_PRIVATE = "export/hosts.private"
    INVENTORY_FILE = "export/inv.ini"
    # JENKINS_PASSWORD_FILE = "export/jenkins_password.txt"
end
