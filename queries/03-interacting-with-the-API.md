# Interacting with the API

The API is available at `http://localhost:9090/api/v1/`.
For example quering the API for the `up` and `node_cpu_seconds_total` timeseries:

```Shell
curl -g 'http://localhost:9090/api/v1/series?'
    --data-urlencode 'match[]=up{job="alertmanager"}'
    --data-urlencode 'match[]=node_cpu_seconds_total{mode="user"}'
```

returns:

```Json
{"status":"success","data":[{"__name__":"node_cpu_seconds_total","cpu":"0","instance":"localhost:9100","job":"node","mode":"user"},{"__name__":"node_cpu_seconds_total","cpu":"1","instance":"localhost:9100","job":"node","mode":"user"},{"__name__":"node_cpu_seconds_total","cpu":"2","instance":"localhost:9100","job":"node","mode":"user"},{"__name__":"node_cpu_seconds_total","cpu":"3","instance":"localhost:9100","job":"node","mode":"user"}]}
```
