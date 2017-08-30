# == Class profile_mssql::install
#
# This class is called from profile_mssql for install.
#
class profile_mssql::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # install network time sync
  include 'winntp'

  # init all new disks
  exec { 'format_all_raw':
    command   => file('profile_mssql/format_all_raw.ps1'),
    provider  => powershell,
    logoutput => true,
    before    => Class['windows_sql'],
  }

  # install sql server
  class {'windows_sql':
    features            => $::profile_mssql::params::features,
    instancedir         => $::profile_mssql::params::instancedir,
    sqluserdbdir        => $::profile_mssql::params::sqluserdbdir,
    sqluserdblogdir     => $::profile_mssql::params::sqluserdblogdir,
    sqltempdbdir        => $::profile_mssql::params::sqltempdbdir,
    sqltempdblogdir     => $::profile_mssql::params::sqltempdblogdir,
    pid                 => $::profile_mssql::params::pid,
    isopath             => $::profile_mssql::params::isopath,
    securitymode        => $::profile_mssql::params::securitymode,
    sapwd               => $::profile_mssql::params::sapwd,
    mode                => $::profile_mssql::params::mode,
  }

#  class { '::sqlserver':
#    backup_dir       => $::profile_mssql::params::backup_dir,
#    database_dir     => $::profile_mssql::params::database_dir,
#    database_log_dir => $::profile_mssql::params::database_log_dir,
#    edition          => $::profile_mssql::params::edition,
#    features         => $::profile_mssql::params::features,
#    force_english    => $::profile_mssql::params::force_english,
#    instance_dir     => $::profile_mssql::params::instance_dir,
#    instance_name    => $::profile_mssql::params::instance_name,
#    license          => $::profile_mssql::params::license,
#    license_type     => $::profile_mssql::params::license_type,
#    sa_password      => $::profile_mssql::params::sa_password,
#    source           => $::profile_mssql::params::source,
#  }
}
