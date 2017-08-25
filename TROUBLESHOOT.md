It may be possible that the connection to Scality Cloud was lost prematurely. In
such a case, in the nohup.out file, you might see a message such as:

```
Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
```

To resolve this, try removing your terraform ssh key on Scality Cloud, stopping
the process issued by `./reset.sh` and rerunning the script.

It is also possible you might see an error like:

```
{"forbidden": {"message": "Quota exceeded for cores: Requested 8, but already used 120 of 120 cores", "code": 403}}
```

In that case, remove the necessary number of instances and volumes (and your
terraform key if there is one). Then rerun `./reset.sh`.
