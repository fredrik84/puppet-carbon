#
define carbon::storage_schema (
  String                                             $pattern,
  Array[Pattern['\A\d+[smhdwy]?:\d+[smhdwy]?\Z'], 1] $retentions,
  String                                             $order      = '10',
) {

  if ! defined(Class['::carbon']) {
    fail('You must include the carbon base class before using any carbon defined resources')
  }

  ::concat::fragment { "${::carbon::conf_dir}/storage-schemas.conf ${name}":
    content => template("${module_name}/storage-schemas.conf.erb"),
    order   => $order,
    target  => "${::carbon::conf_dir}/storage-schemas.conf",
  }
}
