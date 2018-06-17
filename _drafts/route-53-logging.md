---
title: Logging route53
date: 2018-06-17
author: Tim Fletcher
layout: post
permalink: /2018/06/turning-hp-microserver-sas-box/
feature-img: "assets/img/pexels/locks.jpeg"
thumbnail: "assets/img/pexels/locks.jpeg"
tags:
  - Tech
  - Storage
---

# Why Log DNS?

Understanding where your traffic and thus customers are coming from is useful information. Some example of why DNS logs are useful; understanding your traffic profile and ensuring resources are correctly geolocated or from a security perspective the logs can highlight intelligence gathering before attacks.

# What is route53?

Route53 is Amazon’s DNS service, that provides a global resilience and traffic routing. Amazon announced last year support for query logging with Route53 (https://aws.amazon.com/about-aws/whats-new/2017/09/amazon-route-53-announces-support-for-dns-query-logging/). 

# How we log route53:

We are heavy users of the Elastic (nee ELK) stack so the obvious way to deal with the new route53 logs was our hooking it into our logstash pipelines to Elasticsearch. To do this we read the logs out of cloudwatch, do some basic grok processing with logstash and write them out to Elasticsearch.

Fortunately there is a logstash input module for cloudwatch logs https://github.com/lukewaite/logstash-input-cloudwatch-log. The cloudwatch input module needs an AWS key with at least read and filter access to the cloud watch log stream. There are multiple ways to get the key to logstash.

The final step is to grok the logs into useful chunks of information for storage in Elasticsearch, this is the basic grok pattern we use for the messages: 

```
match => { "message" => “%{NUMBER:version} %{TIMESTAMP_ISO8601:timestamp} %{WORD:ZoneID} %{DATA:query} %{WORD:query_type} %{WORD:response} %{WORD:protocol} %{WORD:edge_location} %{IP:resolverIPAddress} %{GREEDYDATA:clientSubnet}" }
```

Once we have the message broken up into useful parts 

# Getting this working for yourself

We are using docker so there is an example of the container we use to ingest, process and write the logs out to Elastic search.

https://github.com/TimJDFletcher/logstash-route53-ingest
