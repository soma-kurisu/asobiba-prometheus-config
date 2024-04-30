# up is a special metric added by Prometheus when it performs a scrape
up

# calculate how many samples Prometheus is ingesting per second averaged over one minute
rate(prometheus_tsdb_head_samples_appended_total[1m])

# graph the memory usage of just the Node Exporters
# is the memory used by the Node Exporter process itself
process_resident_memory_bytes{job="node"}

rate(node_network_receive_bytes_total[1m])

rate(hello_worlds_total[1m])

rate(hello_world_exceptions_total[1m])
# calculate the more useful ratio of exceptions
# gaps in the exception ratio graph for periods when there are no requests. This is because we are dividing by zero, => NaN (Not a Number)
rate(hello_world_exceptions_total[1m])
/
rate(hello_worlds_total[1m])

# Attempting to increase a counter by a negative number is considered to be a programming error and will cause an exception to be raised.
rate(hello_world_sales_euro_total[1m])

# will tell how many seconds it is since the last request was made.
time() - hello_world_last_time_seconds

# return the per-second rate of Hello World requests
rate(hello_world_latency_summary_seconds_count[1m])
# the amount of time spent responding to requests per second
rate(hello_world_latency_summary_seconds_sum[1m])
# the average latency over the last minute
rate(hello_world_latency_summary_seconds_sum[1m])
/
rate(hello_world_latency_summary_seconds_count[1m])

# the histogram_quantile PromQL function can calculate a quantile from the buckets. For example, the 0.95 quantile (95th percentile) would be:
# the rate is needed as the buckets’ time series are counters.
histogram_quantile(0.95, rate(hello_world_latency_histogram_seconds_bucket[1m]))

# SLAS AND QUANTILES => tools like Pyrra can assist in managing SLOs
# Latency SLAs often expressed as 95th percentile latency at most 500ms
# by having a 500ms bucket in histogram, can calculate ratio of requests that take over 500ms:
hello_world_latency_histogram_seconds_bucket{le="0.5"}
/ ignoring(le)
hello_world_latency_histogram_seconds_bucket{le="+Inf"}
# it is recommended debugging latency issues primarily with averages rather than quantiles
# histogram also includes _sum and _count time series
rate(hello_world_latency_histogram_seconds_sum[1m])
/
rate(hello_world_latency_histogram_seconds_count[1m])
