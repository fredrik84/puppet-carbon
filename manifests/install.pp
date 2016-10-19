#
class carbon::install {

  package { $::carbon::package_name:
    ensure => present,
  }
}
