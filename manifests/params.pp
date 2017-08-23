# == Class profile_mssql::params
#
# This class is meant to be called from profile_mssql.
# It sets variables according to platform.
#
class profile_mssql::params {
  case $::osfamily {
    'Windows': {
      $package_name = 'profile_mssql'
      $service_name = 'profile_mssql'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
