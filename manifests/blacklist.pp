#
define carbon::blacklist (
  String $pattern,
  String $order   = '10',
) {

  if ! defined(Class['::carbon']) {
    fail('You must include the carbon base class before using any carbon defined resources')
  }

  ::concat::fragment { "${::carbon::conf_dir}/blacklist.conf ${name}":
    content => inline_template("<%= @pattern %>\n"),
    order   => $order,
    target  => "${::carbon::conf_dir}/blacklist.conf",
  }
}
