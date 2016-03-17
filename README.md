# Logstash Plugin

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## Documentation


This is a fork of logstash-codec-line (addedd CSV output based on template). Useful for webHDFS output plugin (save CSV files on HDFS). This codec will remove all empty variables like %{[var1]} or %{[array][var2]}.
