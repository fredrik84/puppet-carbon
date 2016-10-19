#
define carbon::rewrite_rule (
  String              $pattern,
  Enum['pre', 'post'] $section,
  Optional[String]    $replacement = undef,
  String              $order       = '10',
) {

  if ! defined(Class['::carbon']) {
    fail('You must include the carbon base class before using any carbon defined resources')
  }

  $_order = $section ? {
    'pre'  => "2${order}",
    'post' => "4${order}",
  }

  ::concat::fragment { "${::carbon::conf_dir}/rewrite-rules.conf ${name}":
    content => template("${module_name}/rewrite-rules.conf.erb"),
    order   => $_order,
    target  => "${::carbon::conf_dir}/rewrite-rules.conf",
  }
}
