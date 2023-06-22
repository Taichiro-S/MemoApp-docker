#!/bin/bash

# Environment variables file name
SETENV_SHELL="/etc/profile.d/load-params.sh"
APPENV_FILE="/etc/params"

# Load environmental variables
INSTANCE_ID=$(curl 169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl 169.254.169.254/latest/meta-data/placement/region)
ZONE=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone)

VPC_ID=$(aws ec2 describe-instances --region ${REGION} --instance-ids ${INSTANCE_ID} --query "Reservations[0].Instances[0].NetworkInterfaces[0].VpcId" --output text)
VPC_NAME=$(aws ec2 describe-vpcs --region ${REGION} --vpc-ids ${VPC_ID} --query "Vpcs[0].Tags[?Key=='Name'].Value" --output text)
VPC_PROJECT=$(aws ec2 describe-vpcs --region ${REGION} --vpc-ids ${VPC_ID} --query "Vpcs[0].Tags[?Key=='Project'].Value" --output text)
VPC_ENV=$(aws ec2 describe-vpcs --region ${REGION} --vpc-ids ${VPC_ID} --query "Vpcs[0].Tags[?Key=='Env'].Value" --output text)

EC2_NAME=$(aws ec2 describe-instances --region ${REGION} --instance-ids ${INSTANCE_ID} --query "Reservations[0].Instances[0].Tags[?Key=='Name'].Value" --output text)
EC2_TYPE=$(aws ec2 describe-instances --region ${REGION} --instance-ids ${INSTANCE_ID} --query "Reservations[0].Instances[0].Tags[?Key=='Type'].Value" --output text)

SSM_PARAMETER_STORE=$(aws ssm get-parameters-by-path --region ${REGION} --path "/${VPC_PROJECT}/${VPC_ENV}/${EC2_TYPE}" --with-decryption)

# Output environment initialize scripts.
cat > "${SETENV_SHELL}" <<EOF
#
# [$(date '+%Y-%m-%dT%H:%M:%S+09:00' -d '9 hour')] Initialized scripts.
#
export INSTANCE_ID=${INSTANCE_ID}
export REGION=${REGION}
export ZONE=${ZONE}
export VPC_ID=${VPC_ID}
export VPC_NAME="${VPC_NAME}"
export VPC_PROJECT="${VPC_PROJECT}"
export VPC_ENV="${VPC_ENV}"
export EC2_NAME="${EC2_NAME}"
export EC2_TYPE="${EC2_TYPE}"
EOF

for PARAMS in $(echo ${SSM_PARAMETER_STORE} | /usr/local/bin/jq -r '.Parameters[] | .Name + "=" + .Value'); do
  echo "export ${PARAMS##*/}"
done >> "${SETENV_SHELL}"

# Output environment file.
mkdir -p ${APPENV_FILE%/*}
sed "s/^export //g" ${SETENV_SHELL} > ${APPENV_FILE}

# Load environments.
chmod +x "${SETENV_SHELL}"
source "${SETENV_SHELL}"