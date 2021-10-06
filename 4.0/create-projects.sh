export $cpd_instance=cp4d
export $cpd_instance_tether=cp4d-tether

# Create Projects
# Create ibm-common-services
cat <<EOF |oc apply -f -
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    openshift.io/description: "IBM Common Services"
    openshift.io/display-name: "IBM Common Services"
    # Required for scheduling on IBM Spectrum Scale CNSA Nodes
    # openshift.io/node-selector: scale=true
  name: ibm-common-services
EOF
# Create cp4d (instance namespace)
cat <<EOF |oc apply -f -
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    openshift.io/description: "Cloud Pak for Data"
    openshift.io/display-name: "Cloud Pak for Data"
    # Required for scheduling on IBM Spectrum Scale CNSA Nodes
    # openshift.io/node-selector: scale=true
  name: cp4d
EOF

# Create OperatorGroup
cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha2
kind: OperatorGroup
metadata:
  name: operatorgroup
  namespace: ibm-common-services
spec:
  targetNamespaces:
  - ibm-common-services
EOF




cat << EOF | oc apply -f -
apiVersion: machineconfiguration.openshift.io/v1
kind: KubeletConfig
metadata:
  name: db2u-kubelet
spec:
  machineConfigPoolSelector:
    matchLabels:
      db2u-kubelet: sysctl
  kubeletConfig:
      allowedUnsafeSysctls:
      - "kernel.msg*"
      - "kernel.shm*"
      - "kernel.sem"
EOF