# carbon

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-carbon.svg?branch=master)](https://travis-ci.org/bodgit/puppet-carbon)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-carbon/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-carbon?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/carbon.svg)](https://forge.puppetlabs.com/bodgit/carbon)
[![Dependency Status](https://gemnasium.com/bodgit/puppet-carbon.svg)](https://gemnasium.com/bodgit/puppet-carbon)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with carbon](#setup)
    * [What carbon affects](#what-carbon-affects)
    * [Beginning with carbon](#beginning-with-carbon)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Classes and Defined Types](#classes-and-defined-types)
        * [Class: carbon](#class-carbon)
        * [Defined Type: carbon::aggregation_rule](#defined-type-carbonaggregation_rule)
        * [Defined Type: carbon::aggregator](#defined-type-carbonaggregator)
        * [Defined Type: carbon::blacklist](#defined-type-carbonblacklist)
        * [Defined Type: carbon::cache](#defined-type-carboncache)
        * [Defined Type: carbon::relay](#defined-type-carbonrelay)
        * [Defined Type: carbon::relay_rule](#defined-type-carbonrelay_rule)
        * [Defined Type: carbon::rewrite_rule](#defined-type-carbonrewrite_rule)
        * [Defined Type: carbon::storage_aggregation](#defined-type-carbonstorage_aggregation)
        * [Defined Type: carbon::storage_schema](#defined-type-carbonstorage_schema)
        * [Defined Type: carbon::whitelist](#defined-type-carbonwhitelist)
    * [Examples](#examples)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module manages the Carbon daemons.

## Module Description

This module installs the Carbon packages, configures the carbon, relay, and
aggregator daemons and runs them. It currently leverages systemd to support
running multiple instances of each. It also manages the various rules and
lists supported by each.

## Setup

If running on Puppet 3.x you will need to have the future parser enabled. On
RHEL/CentOS platforms you will need to enable the EPEL repository first.

### What carbon affects

* The package(s) providing the Carbon software.
* The various `/etc/carbon/*.conf` configuration files.
* The systemd unit file for each daemon instance.

### Beginning with carbon

```puppet
include ::carbon
```

## Usage

### Classes and Defined Types

#### Class: `carbon`

**Parameters within `carbon`:**

##### `aggregation_rules

A hash of [carbon::aggregation_rule](#defined-type-carbonaggregation_rule)
instances to create.

##### `aggregators`

A hash of [carbon::aggregator](#defined-type-carbonaggregator) instances to
create.

##### `blacklists`

A hash of [carbon::blacklist](#defined-type-carbonblacklist) instances to
create.

##### `caches`

A hash of [carbon::cache](#defined-type-carboncache) instances to create.

##### `conf_dir`

The base configuration directory, defaults to `/etc/carbon`.

##### `local_data_dir`

The directory where whisper files are written, defaults to
`${storage_dir}/whisper`.

##### `log_dir`

The log directory, defaults to `/var/log/carbon`.

##### `package_name`

The name of the package to install that provides the Carbon software.

##### `pid_dir`

The directory where PID files are written, defaults to `/var/run`.

##### `relay_rules`

A hash of [carbon::relay_rule](#defined-type-carbonrelay_rule) instances to
create.

##### `relays`

A hash of [carbon::relay](#defined-type-carbonrelay) instances to create.

##### `rewrite_rules`

A hash of [carbon::rewrite_rule](#defined-type-carbonrewrite_rule) instances
to create.

##### `storage_dir`

The base storage dіrectory, defaults to `/var/lib/carbon`.

##### `storage_aggregations`

A hash of
[carbon::storage_aggregation](#defined-type-carbonstorage_aggregation)
instances to create.

##### `storage_schemas`

A hash of [carbon::storage_schema](#defined-type-carbonstorage_schema)
instances to create.

##### `user`

The user to run as, defaults to `carbon`.

##### `whitelists`

A hash of [carbon::whitelist](#defined-type-carbonwhitelist) instances to
create.

##### `whitelists_dir`

The directory used for whitelisting, defaults to `/var/lib/carbon/lists`.

#### Defined Type: `carbon::aggregation_rule`

**Parameters within `carbon::aggregation_rule`:**

##### `name`

The name of the rule.

##### `frequency`

How frequently to aggregate.

##### `input_pattern`

Input pattern for matching incoming metrics.

##### `method`

One of `avg` or `sum`.

##### `output_template`

The template for the outgoing aggregated metrics.

##### `order`

Used to place the rule in the file, defaults to `'10'`.

#### Defined Type: `carbon::aggregator`

**Parameters within `carbon::aggregator`:**

##### `name`

The name of the aggregator instance, should be a single letter `a`-`z`.

##### `ensure`

The running state of the instance, should be `stopped` or `running`.

##### `enable`

Boolean whether to enable the instance.

##### `line_receiver_interface`

Maps to the `LINE_RECEIVER_INTERFACE` setting.

##### `line_receiver_port`

Maps to the `LINE_RECEIVER_PORT` setting.

##### `pickle_receiver_interface`

Maps to the `PICKLE_RECEIVER_INTERFACE` setting.

##### `pickle_receiver_port`

Maps to the `PICKLE_RECEIVER_PORT` setting.

##### `log_listener_connections`

Maps to the `LOG_LISTENER_CONNECTIONS` setting.

##### `forward_all`

Maps to the `FORWARD_ALL` setting.

##### `destinations`

An array of hashes for each destination instance. Hash must contain `host`
and `port` keys and optionally an `instance` key. Builds the `DESTINATIONS`
setting.

##### `replication_factor`

Maps to the `REPLICATION_FACTOR` setting.

##### `max_queue_size`

Maps to the `MAX_QUEUE_SIZE` setting.

##### `use_flow_control`

Maps to the `USE_FLOW_CONTROL` setting.

##### `max_datapoints_per_message`

Maps to the `MAX_DATAPOINTS_PER_MESSAGE` setting.

##### `max_aggregation_intervals`

Maps to the `MAX_AGGREGATION_INTERVALS` setting.

##### `write_back_frequency`

Maps to the `WRITE_BACK_FREQUENCY` setting.

##### `use_whitelist`

Maps to the `USE_WHITELIST` setting.

##### `carbon_metric_prefix`

Maps to the `CARBON_METRIC_PREFIX` setting.

##### `carbon_metric_interval`

Maps to the `CARBON_METRIC_INTERVAL` setting.

#### Defined Type: `carbon::blacklist`

**Parameters within `carbon::blacklist`:**

##### `name`

The name of the blacklist entry.

##### `pattern`

The regular expression for the blacklist pattern.

##### `order`

Where to place the blacklist in the file, defaults to `'10'`.

#### Defined Type: `carbon::cache`

**Parameters within `carbon::cache`:**

##### `name`

The name of the cache instance, should be a single letter `a`-`z`.

##### `ensure`

The running state of the instance, should be `stopped` or `running`.

##### `enable`

Boolean whether to enable the instance.

##### `storage_dir`

Maps to the `STORAGE_DIR` setting. Defaults to `/var/lib/carbon`.

##### `local_data_dir`

Maps to the `LOCAL_DATA_DIR` setting. Defaults to `${storage_dir}/whisper`.

##### `whitelists_dir`

Maps to the `WHITELISTS_DIR` setting. Defaults to `${storage_dir}/lists`.

##### `conf_dir`

Maps to the `CONF_DIR` setting. Defaults to `/etc/carbon`.

##### `log_dir`

Maps to the `LOG_DIR` setting. Defaults to `/var/log/carbon`.

##### `pid_dir`

Maps to the `PID_DIR` setting. Defaults to `/var/run`.

##### `enable_logrotation`

Maps to the `ENABLE_LOGROTATION` setting.

##### `user`

Maps to the `USER` setting. Defaults to `carbon`.

##### `max_cache_size`

Maps to the `MAX_CACHE_SIZE` setting.

##### `max_updates_per_second`

Maps to the `MAX_UPDATES_PER_SECOND` setting.

##### `max_updates_per_second_on_shutdown`

Maps to the `MAX_UPDATES_PER_SECOND_ON_SHUTDOWN` setting.

##### `max_creates_per_minute`

Maps to the `MAX_CREATES_PER_MINUTE` setting.

##### `line_receiver_interface`

Maps to the `LINE_RECEIVER_INTERFACE` setting.

##### `line_receiver_port`

Maps to the `LINE_RECEIVER_PORT` setting.

##### `line_receiver_backlog`

Maps to the `LINE_RECEIVER_BACKLOG` setting.

##### `enable_udp_listener`

Maps to the `ENABLE_UDP_LISTENER` setting.

##### `udp_receiver_interface`

Maps to the `UDP_RECEIVER_INTERFACE` setting.

##### `udp_receiver_port`

Maps to the `UDP_RECEIVER_PORT` setting.

##### `pickle_receiver_interface`

Maps to the `PICKLE_RECEIVER_INTERFACE` setting.

##### `pickle_receiver_port`

Maps to the `PICKLE_RECEIVER_PORT` setting.

##### `pickle_receiver_backlog`

Maps to the `PICKLE_RECEIVER_BACKLOG` setting.

##### `log_listener_connections`

Maps to the `LOG_LISTENER_CONNECTIONS` setting.

##### `use_insecure_unpickler`

Maps to the `USE_INSECURE_UNPICKLER` setting.

##### `cache_query_interface`

Maps to the `CACHE_QUERY_INTERFACE` setting.

##### `cache_query_port`

Maps to the `CACHE_QUERY_PORT` setting.

##### `cache_query_backlog`

Maps to the `CACHE_QUERY_BACKLOG` setting.

##### `use_flow_control`

Maps to the `USE_FLOW_CONTROL` setting.

##### `log_updates`

Maps to the `LOG_UPDATES` setting.

##### `log_cache_hits`

Maps to the `LOG_CACHE_HITS` setting.

##### `log_cache_queue_sorts`

Maps to the `LOG_CACHE_QUEUE_SORTS` setting.

##### `cache_write_strategy`

Maps to the `CACHE_WRITE_STRATEGY` setting.

##### `whisper_autoflush`

Maps to the `WHISPER_AUTOFLUSH` setting.

##### `whisper_sparse_create`

Maps to the `WHISPER_SPARSE_CREATE` setting.

##### `whisper_fallocate_create`

Maps to the `WHISPER_FALLOCATE_CREATE` setting.

##### `whisper_lock_writes`

Maps to the `WHISPER_LOCK_WRITES` setting.

##### `use_whitelist`

Maps to the `USE_WHITELIST` setting.

##### `carbon_metric_prefix`

Maps to the `CARBON_METRIC_PREFIX` setting.

##### `carbon_metric_interval`

Maps to the `CARBON_METRIC_INTERVAL` setting.

##### `enable_amqp`

Maps to the `ENABLE_AMQP` setting.

##### `amqp_verbose`

Maps to the `AMQP_VERBOSE` setting.

##### `amqp_host`

Maps to the `AMQP_HOST` setting.

##### `amqp_port`

Maps to the `AMQP_PORT` setting.

##### `amqp_vhost`

Maps to the `AMQP_VHOST` setting.

##### `amqp_user`

Maps to the `AMQP_USER` setting.

##### `amqp_password`

Maps to the `AMQP_PASSWORD` setting.

##### `amqp_exchange`

Maps to the `AMQP_EXCHANGE` setting.

##### `amqp_metric_name_in_body`

Maps to the `AMQP_METRIC_NAME_IN_BODY` setting.

##### `enable_manhole`

Maps to the `ENABLE_MANHOLE` setting.

##### `manhole_interface`

Maps to the `MANHOLE_INTERFACE` setting.

##### `manhole_port`

Maps to the `MANHOLE_PORT` setting.

##### `manhole_user`

Maps to the `MANHOLE_USER` setting.

##### `manhole_public_key`

Maps to the `MANHOLE_PUBLIC_KEY` setting.

##### `bind_patterns`

An array of AMQP bind patterns. Builds the `BIND_PATTERNS` setting.

#### Defined Type: `carbon::relay`

**Parameters within `carbon::relay`:**

##### `name`

The name of the relay instance, should be a single letter `a`-`z`.

##### `ensure`

The running state of the instance, should be `stopped` or `running`.

##### `enable`

Boolean whether to enable the instance.

##### `line_receiver_interface`

Maps to the `LINE_RECEIVER_INTERFACE` setting.

##### `line_receiver_port`

Maps to the `LINE_RECEIVER_PORT` setting.

##### `pickle_receiver_interface`

Maps to the `PICKLE_RECEIVER_INTERFACE` setting.

##### `pickle_receiver_port`

Maps to the `PICKLE_RECEIVER_PORT` setting.

##### `log_listener_connections`

Maps to the `LOG_LISTENER_CONNECTIONS` setting.

##### `relay_method`

Maps to the `RELAY_METHOD` setting. One of `rules`, `consistent-hashing`, or
`aggregated-consistent-hashing`.

##### `replication_factor`

Maps to the `REPLICATION_FACTOR` setting.

##### `diverse_replicas`

Maps to the `DIVERSE_REPLICAS` setting.

##### `destinations`

An array of hashes for each destination instance. Hash must contain `host`
and `port` keys and optionally an `instance` key. Builds the `DESTINATIONS`
setting.

##### `max_datapoints_per_message`

Maps to the `MAX_DATAPOINTS_PER_MESSAGE` setting.

##### `max_queue_size`

Maps to the `MAX_QUEUE_SIZE` setting.

##### `queue_low_watermark_pct`

Maps to the `QUEUE_LOW_WATERMARK_PCT` setting.

##### `use_flow_control`

Maps to the `USE_FLOW_CONTROL` setting.

##### `use_whitelist`

Maps to the `USE_WHITELIST` setting.

##### `carbon_metric_prefix`

Maps to the `CARBON_METRIC_PREFIX` setting.

##### `carbon_metric_interval`

Maps to the `CARBON_METRIC_INTERVAL` setting.

#### Defined Type: `carbon::relay_rule`

**Parameters within `carbon::relay_rule`:**

##### `name`

The name of the rule.

##### `destinations`

An array of hashes for each destination instance. Hash must contain `host`
and `port` keys and optionally an `instance` key.

##### `continue`

Whether to drop through to further rules.

##### `default`

Marks the default relay rule.

##### `pattern`

The regular expression for matching metrics.

##### `order`

Used to place the rule in the file, defaults to `'10'`.

#### Defined Type: `carbon::rewrite_rule`

**Parameters within `carbon::rewrite_rule`:**

##### `name`

The name of the rule.

##### `pattern`

The regular expression for matching metrics.

##### `section`

One of `pre` or `post`.

##### `replacement`

The replacement pattern to apply.

##### `order`

Used to place the rule in the file, defaults to `'10'`.

#### Defined Type: `carbon::storage_aggregation`

**Parameters within `carbon::storage_aggregation`:**

##### `name`

The name of the rule.

##### `aggregation_method`

One of `average`, `sum`, `last`, `max` or `min`.

##### `pattern`

The regular expression for matching metrics.

##### `x_files_factor`

Represents the ratio of datapoints needed in order to aggregate accurately.

##### `order`

Used to place the rule in the file, defaults to `'10'`.

#### Defined Type: `carbon::storage_schema`

**Parameters within `carbon::storage_schema`:**

##### `name`

The name of the rule.

##### `pattern`

The regular expression for matching metrics.

##### `retentions`

An array of data retention policies.

##### `order`

Used to place the rule in the file, defaults to `'10'`.

#### Defined Type: `carbon::whitelist`

**Parameters within `carbon::whitelist`:**

##### `name`

The name of the whitelist entry.

##### `pattern`

The regular expression for the whitelist pattern.

##### `order`

Where to place the whitelist in the file, defaults to `'10'`.

### Examples

Install and create a sole cache instance (package defaults):

```puppet
include ::carbon
```

Extend the above to add a second cache instance with a relay instance in front
of both balancing metrics between them.

```puppet
class { '::carbon':
  relays => {},
}

::carbon::cache { 'b':
  ensure               => running,
  enable               => true,
  line_receiver_port   => 2103,
  pickle_receiver_port => 2104,
  cache_query_port     => 7102,
}

::carbon::relay { 'a':
  ensure                     => running,
  enable                     => true,
  line_receiver_interface    => '0.0.0.0',
  line_receiver_port         => 2013,
  pickle_receiver_interface  => '0.0.0.0',
  pickle_receiver_port       => 2014,
  log_listener_connections   => true,
  relay_method               => 'consistent-hashing',
  replication_factor         => 1,
  destinations               => [
    {
      'host'     => '127.0.0.1',
      'port'     => 2004,
      'instance' => 'a',
    },
    {
      'host'     => '127.0.0.1',
      'port'     => 2104,
      'instance' => 'b',
    },
  ],
  max_datapoints_per_message => 500,
  max_queue_size             => 10000,
  queue_low_watermark_pct    => 0.8,
  use_flow_control           => true,
}
```

## Reference

### Classes

#### Public Classes

* [`carbon`](#class-carbon): Main class for managing the Carbon daemons.

#### Private Classes

* `carbon::install`: Handles Carbon installation.
* `carbon::config`: Handles Carbon configuration.
* `carbon::params`: Different configuration data for different systems.
* `carbon::service`: Handles stopping the default services.

### Defined Types

#### Public Defined Types

* [`carbon::aggregation_rule`](#defined-type-carbonaggregation_rule): Handles
  aggregation rules.
* [`carbon::aggregator`](#defined-type-carbonaggregator): Handles creating
  aggregator instances.
* [`carbon::blacklist`](#defined-type-carbonblacklist): Handles blacklist
  rules.
* [`carbon::cache`](#defined-type-carboncache): Handles creating cache
  instances.
* [`carbon::relay`](#defined-type-carbonrelay): Handles creating relay
  instances.
* [`carbon::relay_rule`](#defined-type-carbonrelay_rule): Handles relay rules.
* [`carbon::rewrite_rule`](#defined-type-carbonrewrite_rule): Handles rewrite
  rules.
* [`carbon::storage_aggregation`](#defined-type-carbonstorage_aggregation):
  Handles storage aggregation rules.
* [`carbon::storage_schema`](#defined-type-carbonstorage_schema): Handles
  storage schema rules.
* [`carbon::whitelist`](#defined-type-carbonwhitelist): Handles whitelist
  rules.

## Limitations

This module leverages systemd to create multiple instances of the three
daemons.

This module has been built on and tested against Puppet 3.0 and higher.

The module has been tested on:

* RedHat/CentOS Enterprise Linux 7

Testing on other platforms has been light and cannot be guaranteed.

## Development

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-carbon).
