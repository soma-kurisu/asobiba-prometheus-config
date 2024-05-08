# offset and @ modifiers

- https://prometheus.io/docs/prometheus/latest/querying/basics/#modifier

`start()` and `end()` can be used as values for the `@` modifier as special values.

For a range query, they resolve to the start and end of the range query respectively and remain the same for all steps.

- https://prometheus.io/blog/2021/02/18/introducing-the-@-modifier/

Following query plots the `1m` `rate` of `prometheus_http_requests_total`-metric of those series whose `last` `1h` `rate` was among the `top 5`.

Compare result vectors and graphs of (1) `start()`-anchored (2)`end()`-anchored and (3) non-anchored range queries. 

A `topk()` query only makes sense as an *instant query* where you get exactly *k* results, but when run as a *range query*, you can get much more than *k* results since every step is evaluated independently. The `@` *modifier* fixes the *ranking* for all the steps in a range query.

The `topk(5, rate({...}[1h] @ end()))` acts as a ranking function, filtering only the higher values at the *end* of the evaluation interval.

```C
# (1) start()-anchored
rate(prometheus_http_requests_total[1m])
  and
topk(5, 
  rate(prometheus_http_requests_total[1h] @ start())
)
```

```C
# (2) end()-anchored
rate(prometheus_http_requests_total[1m])
  and
topk(5, 
  rate(prometheus_http_requests_total[1h] @ end())
)
```

```C
# (3) non-anchored
rate(prometheus_http_requests_total[1m])
  and
topk(5, 
  rate(prometheus_http_requests_total[1h])
)
```