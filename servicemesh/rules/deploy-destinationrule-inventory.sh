#!/bin/bash

# Environment
. ../0-environment.sh

# Cleaning resources
oc delete destinationrule -n ${MSA_PROJECT_NAME} inventory
oc delete virtualservice -n ${MSA_PROJECT_NAME} inventory

cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: inventory
spec:
  host: inventory
  subsets:
  - labels:
      version: 1.0.0
    name: version-v1
EOF

cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: inventory
spec:
  hosts:
  - inventory
  http:
  - route:
    - destination:
        host: inventory
        subset: version-v1
      weight: 100
EOF
