# Get latest packages
sudo apt update

# Install ecr login helper
sudo apt -y install amazon-ecr-credential-helper
sudo cp bin/docker-credential-sso-ecr-login /usr/bin/docker-credential-sso-ecr-login

# Setup docker config w/ login helper
echo "Updating Docker Configuration"

# Verify docker config exhists before making changes to the file
if [ ! -f  ~/.docker/config.json ]; then
  echo "{}" >> ~/.docker/config.json
fi

AWS_ECR=196709151182.dkr.ecr.us-east-1.amazonaws.com
tmp=$(mktemp)
# Modify only exhisting values required
AWS_ECR=$AWS_ECR jq '.auths[env.AWS_ECR] = {}' ~/.docker/config.json > "$tmp" && cp "$tmp" ~/.docker/config.json
AWS_ECR=$AWS_ECR jq '.credHelpers[env.AWS_ECR] = "sso-ecr-login"' ~/.docker/config.json > "$tmp" && cp "$tmp" ~/.docker/config.json
rm $tmp
echo "Resulting Docker Configuration"

cat ~/.docker/config.json | jq
# End docker config setup

# Setup aws sso login
cp -r .aws ~
pip install aws2-wrap
sudo cp bin/aws-save-creds /usr/bin/aws-save-creds

# Setup k8s
cp -r .kube ~

echo "Dotfiles Installation Successful" >> ~/dot-success.txt
