# offset and @ modifiers

- https://prometheus.io/docs/prometheus/latest/querying/basics/#modifier

`start()` and `end()` can be used as values for the `@` modifier as special values.

For a range query, they resolve to the start and end of the range query respectively and remain the same for all steps.

- https://prometheus.io/blog/2021/02/18/introducing-the-@-modifier/

Following query plots the `1m` `rate` of `http_requests_total` of those series whose `last` `1h` `rate` was among the `top 5`.

```C
rate(http_requests_total[1m])
  and
topk(5, rate(http_requests_total[1h] @ end()))
```
