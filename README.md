# Setup H.O.M.E.R.

A project that handles automation of the H.O.M.E.R. setup and deployment.

## Quickstart

This guide assumes:

* Docker is installed

Make sure you have enough room to generate the required Scality Cloud instances:
* Remove images
* Remove volumes
* Remove any keys generated from previous runs

Fill in the exported environment variables declared in `setup.sh`:

```
vim ./setup.sh
```

Now run the setup:

```
chmod +x ./setup.sh && ./setup.sh
```

The last line output from the script will be the container ID where our HOMER is
setup. It should look something like:

```
...
Successfully built aaed4f7af985
Successfully tagged friendlyhomer:latest
231362fcfd542075e73428d9e77b5479e0f03fa75ace2461e6cf0c3a32cb9a2f
```

We can use that ID to exec into the docker container:

```
docker exec -it 231362fcfd542075e73428d9e77b5479e0f03fa75ace2461e6cf0c3a32cb9a2f bash
```

Now clone the HOMER project:

```
git clone https://github.com/scality/HOMER
```

Copy open.rc file into the HOMER project:

```
cp open.rc HOMER/ && cd HOMER/
```

User ssh agent:

```
ssh-agent
```

Set the environment variable of the first line of the output something like:

```
SSH_AUTH_SOCK=/tmp/ssh-0fgPrDgXmjE8/agent.81; export SSH_AUTH_SOCK;
```

Now run the open.rc tasK:

```
. open.rc
```

A successful output will look something like:

```
Identity added: /root/.ssh/terraform (/root/.ssh/terraform)
```

Make sure security groups are set in scality cloud to allow 0.0.0.0/0 on port 22

TODO: Add screen shots from scality cloud.

Now set up the environment (you might consider setting parallelism in this file
to 4):

```
./reset.sh backbeat_2sites_12servers
```

You will be prompted with a message:

```
Identity added: /root/.ssh/terraform (/root/.ssh/terraform)
Do you really want to destroy?
  Terraform will delete all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value:
```

Type `yes` and enter.

The setup of Volumes and instances should take some time. Once the instances
have been created, you can exec into the main docker container that has been
assigned with your public IP from your Docker container running locally:

```
ssh root@<public-ip>
```

In the working directory you should find the file nohup.out which contains the
output from your Federation setup on the instances. See it appending to the
file:

```
cd /home/scality/ && \
tail -F nohup.out
```

When open.rc is done successfully, you should see output that looks something
like:

```
Apply complete! Resources: 96 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path:

Outputs:

address = 144.217.45.194
```

If you are manually running tests after the environment has been set up, note
that to run tests in /tmp/bin/tester.py you must be 'scality' user.

```
su scality && \
cd /home/scality/federation && \
bash /tmp/bin/tester.sh
```
