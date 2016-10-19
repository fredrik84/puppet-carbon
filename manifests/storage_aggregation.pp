#
define carbon::storage_aggregation (
  Enum['average', 'sum', 'last', 'max', 'min'] $aggregation_method,
  String                                       $pattern,
  Float[0, 1]                                  $x_files_factor,
  String                                       $order              = '10',
) {

  if ! defined(Class['::carbon']) {
    fail('You must include the carbon base class before using any carbon defined resources')
  }

  ::concat::fragment { "${::carbon::conf_dir}/storage-aggregation.conf ${name}":
    content => template("${module_name}/storage-aggregation.conf.erb"),
    order   => $order,
    target  => "${::carbon::conf_dir}/storage-aggregation.conf",
  }
}
