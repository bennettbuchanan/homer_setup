# Fill in your environment variables
export AWS_ACCESS_KEY_ID=''
export AWS_SECRET_ACCESS_KEY=''
export SCALITY_CLOUD_USERNAME=''
export SCALITY_CLOUD_PASSWORD=''
export SCALITY_CLOUD_EMAIL=''

docker build -t friendlyhomer \
--build-arg AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
--build-arg AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" . && \
docker run -d \
-e SCALITY_CLOUD_EMAIL="$SCALITY_CLOUD_EMAIL" \
-e SCALITY_CLOUD_USERNAME="$SCALITY_CLOUD_USERNAME" \
-e SCALITY_CLOUD_PASSWORD="$SCALITY_CLOUD_PASSWORD" \
friendlyhomer bash -c "while true; do sleep 300s; done"
