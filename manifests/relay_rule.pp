#
define carbon::relay_rule (
  Array[
    Struct[
      {
        'host'               => String,
        'port'               => Integer[0, 65535],
        Optional['instance'] => Pattern['\A[a-z]\Z'],
      }
    ],
    1
  ]                 $destinations,
  Optional[Boolean] $continue     = undef,
  Optional[Boolean] $default      = undef,
  Optional[String]  $pattern      = undef,
  String            $order        = '10',
) {

  if ! defined(Class['::carbon']) {
    fail('You must include the carbon base class before using any carbon defined resources')
  }

  ::concat::fragment { "${::carbon::conf_dir}/relay-rules.conf ${name}":
    content => template("${module_name}/relay-rules.conf.erb"),
    order   => $order,
    target  => "${::carbon::conf_dir}/relay-rules.conf",
  }
}
