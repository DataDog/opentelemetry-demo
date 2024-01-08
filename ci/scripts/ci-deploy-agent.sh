#!/usr/bin/env bash

# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0

# This script is used to deploy collector on demo account cluster

set -euo pipefail
IFS=$'\n\t'

clusterName=$CLUSTER_NAME
clusterArn=$CLUSTER_ARN
region=$REGION
namespace=$NAMESPACE
values=$VALUES

install_agent() {
  # Set the namespace and release name
  release_name="datadog-agent"

  # if repo already exists, helm 3+ will skip
  helm repo add datadog https://helm.datadoghq.com

  # --install will run `helm install` if not already present.
  helm upgrade "${release_name}" -n "${namespace}" datadog/datadog --install \
    -f ./ci/datadog-agent-values.yaml \
    -f "${values}"
}

###########################################################################################################

aws eks --region "${region}" update-kubeconfig --name "${clusterName}"
kubectl config use-context "${clusterArn}"

install_agent
