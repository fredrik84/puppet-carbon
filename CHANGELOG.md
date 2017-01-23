## Release 1.0.1

### Summary

Fix a few small bugs.

#### Bugfixes

- Carbon daemons were not correctly subscribed to `carbon.conf` for changes.
  All files bar `storage-aggregation.conf` and `storage-schemas.conf` are now
  correctly subscribed to.
- The systemd unit files were created incorrectly using a manual symlink which
  breaks on the latest EL7 systemd packages. Letting Puppet manage the services
  itself seems to DTRT.

## Release 1.0.0

### Summary

Initial version.
