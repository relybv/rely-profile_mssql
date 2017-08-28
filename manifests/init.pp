# == Class: profile_mssql
#
# Full description of class profile_mssql here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class profile_mssql
(
  $monitor_address = $::profile_mssql::params::monitor_address,
  $productionlevel = 'production', # options: test, acceptance and production
) inherits ::profile_mssql::params {

  if $monitor_address != undef {
    validate_string($monitor_address)
  }
  class { '::profile_mssql::install': }
  -> class { '::profile_mssql::config': }
  ~> class { '::profile_mssql::service': }
  -> Class['::profile_mssql']
}
