# == Class profile_mssql::params
#
# This class is meant to be called from profile_mssql.
# It sets variables according to platform.
#
class profile_mssql::params {
  $monitor_address = $::monitor_address
  $productionlevel = 'production' # possible values: 'production', 'acceptance', 'test' (default)
  case $productionlevel {
    'production': {
      $sapwd               = 'changeme'
      $securitymode        = 'sql'
      $mode                = 'master'
      $features            = 'SQL,RS_SHP,RS_SHPWFE,TOOLS'
      $pid                 = 'SYOUR-PRODU-CTKEY-OFSQL-2012S'
      $sqlsysadminaccounts = 'SQLAdmin'
      $agtsvcaccount       = 'svc_sqlagt'
      $sqlsvcaccount       = 'svc_sqlsvc'

      $sqluserdbdir        = 'F:\SQLDB'
      $sqltempdbdir        = 'G:\TMPDB'
      $sqluserdblogdir     = 'H:\SQLLOG\DB'
      $sqltempdblogdir     = 'H:\SQLLOG\TEMP'
      $instancedir         = ''
#      $isopath             = 'https://s3.amazonaws.com/rely-software/mssql/en_sql_server_2012_standard_edition_with_service_pack_2_x86_dvd_4689483.iso'
      $isopath             = 'C:\\en_sql_server_2012_standard_edition_with_service_pack_2_x86_dvd_4689483.iso'
    }
    default: {
      $sapwd            = 'changeme'
      $backup_dir       = undef
      $database_dir     = undef
      $database_log_dir = undef
      $edition          = 'Express' # Possible Values: Express, Standard, Enterprise.
      $features         = ['SQL', 'Tools'] # Possible values: SQL, Analysis Services, Integration Services, Reporting Services, Tools.
      $force_english    = true
      $instance_dir     = undef
      $instance_name    = 'MSSQLSERVER'
      $license          = undef  # license key from Microsoft. The value is ignored for SQL Express and for the Evaluation edition
      $license_type     = 'Evaluation' # Possible Values: Evaluation, MSDN, Volume, Retail
      $sa_password      = undef # If provided, SQL Server will be installed with Windows and SQL authentication.
      $source           = undef # specifies the path of the ISO containing the SQL Server installation
    }
  }

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
