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

---
Querying the query-range API for the `hello_worlds_total` timeseries:

```Shell
curl 'http://localhost:9090/api/v1/query_range?' \
    --data-urlencode 'query=hello_worlds_total' \
    --data-urlencode 'start=2024-05-17T12:00:00Z' \
    --data-urlencode 'end=2024-05-17T20:00:00Z' \
    --data-urlencode 'step=300' \
    --data-urlencode 'limit=100'
```

or:

```Shell
curl 'http://localhost:9090/api/v1/query_range?query=hello_worlds_total&start=2024-05-17T12:00:00Z&end=2024-05-17T20:00:00Z&step=300&limit=100'
```

returns:

```Json
{"status":"success","data":{"resultType":"matrix","result":[{"metric":{"__name__":"hello_worlds_total","instance":"localhost:8000","job":"example","status_code":"200"},"values":[[1715970300,"11"],[1715970600,"81"],[1715970900,"146"],[1715971200,"207"],[1715971500,"271"],[1715971800,"340"],[1715972100,"407"],[1715972400,"438"],[1715972700,"438"],[1715973000,"438"]]},{"metric":{"__name__":"hello_worlds_total","instance":"localhost:8000","job":"example","status_code":"201"},"values":[[1715970300,"9"],[1715970600,"26"],[1715970900,"60"],[1715971200,"87"],[1715971500,"116"],[1715971800,"144"],[1715972100,"170"],[1715972400,"185"],[1715972700,"185"],[1715973000,"185"]]},{"metric":{"__name__":"hello_worlds_total","instance":"localhost:8000","job":"example","status_code":"202"},"values":[[1715970300,"5"],[1715970600,"50"],[1715970900,"82"],[1715971200,"126"],[1715971500,"159"],[1715971800,"209"],[1715972100,"253"],[1715972400,"280"],[1715972700,"280"],[1715973000,"280"]]},{"metric":{"__name__":"hello_worlds_total","instance":"localhost:8000","job":"example","status_code":"301"},"values":[[1715970300,"2"],[1715970600,"21"],[1715970900,"36"],[1715971200,"53"],[1715971500,"60"],[1715971800,"80"],[1715972100,"96"],[1715972400,"101"],[1715972700,"101"],[1715973000,"101"]]},{"metric":{"__name__":"hello_worlds_total","instance":"localhost:8000","job":"example","status_code":"400"},"values":[[1715970300,"2"],[1715970600,"10"],[1715970900,"26"],[1715971200,"42"],[1715971500,"52"],[1715971800,"65"],[1715972100,"75"],[1715972400,"79"],[1715972700,"79"],[1715973000,"79"]]},{"metric":{"__name__":"hello_worlds_total","instance":"localhost:8000","job":"example","status_code":"401"},"values":[[1715970300,"2"],[1715970600,"17"],[1715970900,"25"],[1715971200,"38"],[1715971500,"54"],[1715971800,"65"],[1715972100,"75"],[1715972400,"80"],[1715972700,"80"],[1715973000,"80"]]},{"metric":{"__name__":"hello_worlds_total","instance":"localhost:8000","job":"example","status_code":"403"},"values":[[1715970300,"4"],[1715970600,"16"],[1715970900,"24"],[1715971200,"33"],[1715971500,"47"],[1715971800,"55"],[1715972100,"73"],[1715972400,"84"],[1715972700,"84"],[1715973000,"84"]]},{"metric":{"__name__":"hello_worlds_total","instance":"localhost:8000","job":"example","status_code":"404"},"values":[[1715970300,"2"],[1715970600,"6"],[1715970900,"13"],[1715971200,"22"],[1715971500,"30"],[1715971800,"41"],[1715972100,"52"],[1715972400,"57"],[1715972700,"57"],[1715973000,"57"]]},{"metric":{"__name__":"hello_worlds_total","instance":"localhost:8000","job":"example","status_code":"500"},"values":[[1715970600,"6"],[1715970900,"18"],[1715971200,"25"],[1715971500,"28"],[1715971800,"36"],[1715972100,"46"],[1715972400,"48"],[1715972700,"48"],[1715973000,"48"]]}]}}
```