#
define carbon::aggregation_rule (
  Integer[0]         $frequency,
  String             $input_pattern,
  Enum['avg', 'sum'] $method,
  String             $output_template,
  String             $order           = '10',
) {

  if ! defined(Class['::carbon']) {
    fail('You must include the carbon base class before using any carbon defined resources')
  }

  ::concat::fragment { "${::carbon::conf_dir}/aggregation-rules.conf ${name}":
    content => template("${module_name}/aggregation-rules.conf.erb"),
    order   => $order,
    target  => "${::carbon::conf_dir}/aggregation-rules.conf",
  }
}
