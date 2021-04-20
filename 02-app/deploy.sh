#!/bin/bash
set -e

VERSION="v1"

echo "[-] Building Docker image ($VERSION)..."
TOKEN=$(aliyun cr GetAuthorizationToken)
USER=$(echo $TOKEN | jq -r ".data.tempUserName")
PASSWORD=$(echo $TOKEN | jq -r ".data.authorizationToken")
eval "docker login -u $USER -p $PASSWORD registry-intl.eu-central-1.aliyuncs.com"

docker build -t registry-intl.$ALICLOUD_REGION.aliyuncs.com/academy-day/academy-app:$VERSION .
docker push registry-intl.$ALICLOUD_REGION.aliyuncs.com/academy-day/academy-app:$VERSION

echo "[-] Deploying app and infrastructure..."
cd infra/
aliyun cs DescribeClusterUserKubeconfig --ClusterId $(aliyun cs DescribeClusters | jq -r '.[0].cluster_id') | jq -r '.config' > kube.config

export TF_VAR_image=registry-intl.$ALICLOUD_REGION.aliyuncs.com/academy-day/academy-app:$VERSION
export TF_VAR_access_key_id=$ALICLOUD_ACCESS_KEY
export TF_VAR_access_key_secret=$ALICLOUD_SECRET_KEY
export TF_VAR_region=$ALICLOUD_REGION
terraform init
terraform apply -auto-approve

echo "[-] All done!"
