# Fill in your environment variables
export AWS_ACCESS_KEY_ID='<aws-access-key'
export AWS_SECRET_ACCESS_KEY='<aws-secret-access-key>'
export GIT_USER_EMAIL='<git-user-email>'
# For example: 'Jane Doe':
export GIT_USER_NAME='<git-user-name>'
export SCALITY_CLOUD_EMAIL='<scality-cloud-email'
export SCALITY_CLOUD_USERNAME='<sclaity-cloud-username>'
export SCALITY_CLOUD_PASSWORD='<scality-cloud-password>'
# For example, '~/.ssh/id_rsa':
export ABSOLUTE_PATH_TO_PRIVATE_KEY='<absolute-path-to-private-key'
export HOMER_BRANCH='master'

cp "$ABSOLUTE_PATH_TO_PRIVATE_KEY" . && \
docker build -t friendlyhomer \
--build-arg AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
--build-arg AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
--build-arg GIT_USER_EMAIL="$GIT_USER_EMAIL" \
--build-arg GIT_USER_NAME="$GIT_USER_NAME" \
--build-arg HOMER_BRANCH="$HOMER_BRANCH" . && \
docker run -d \
-e SCALITY_CLOUD_EMAIL="$SCALITY_CLOUD_EMAIL" \
-e SCALITY_CLOUD_USERNAME="$SCALITY_CLOUD_USERNAME" \
-e SCALITY_CLOUD_PASSWORD="$SCALITY_CLOUD_PASSWORD" \
friendlyhomer bash -c "while true; do sleep 300s; done"
