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
  $monitor_address = $profile_mssql::params::monitor_address,
  $productionlevel = $profile_mssql::params::productionlevel,
# See http://msdn.microsoft.com/en-us/library/ms144259.aspx
  # Media is required to install
  $media          = $profile_mssql::params::media,,
  $instancename   = $profile_mssql::params::instancename,
  $features       = $profile_mssql::params::features,
  $sapwd          = $profile_mssql::params::sapwd,
  $agtsvcaccount  = $profile_mssql::params::agtsvcaccount,
  $agtsvcpassword = $profile_mssql::params::agtsvcpassword,
  $assvcaccount   = $profile_mssql::params::assvcaccount,
  $assvcpassword  = $profile_mssql::params::assvcpassword,
  $rssvcaccount   = $profile_mssql::params::rssvcaccount,
  $rssvcpassword  = $profile_mssql::params::rssvcpassword,
  $sqlsvcaccount  = $profile_mssql::params::sqlsvcaccount,
  $sqlsvcpassword = $profile_mssql::params::sqlsvcpassword,
  $instancedir    = $profile_mssql::params::instancedir,
  $ascollation    = $profile_mssql::params::ascollation,
  $sqlcollation   = $profile_mssql::params::sqlcollation,
  $admin          = $profile_mssql::params::admin
) inherits ::profile_mssql::params {

  if $monitor_address != undef {
    validate_string($monitor_address)
  }
  class { '::profile_mssql::install': }
  -> class { '::profile_mssql::config': }
  ~> class { '::profile_mssql::service': }
  -> Class['::profile_mssql']
}
