# == Class profile_mssql::install
#
# This class is called from profile_mssql for install.
#
class profile_mssql::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }
  # init all new disks
  include disk_init_win

  # install sql server
  class { '::sqlserver':
    backup_dir       => undef,
    database_dir     => undef,
    database_log_dir => undef,
    edition          => 'Express', # Possible Values: Express, Standard, Enterprise.
    features         => ['SQL', 'Tools'], # Possible values: SQL, Analysis Services, Integration Services, Reporting Services, Tools.
    force_english    => true,
    instance_dir     => undef,
    instance_name    => 'MSSQLSERVER',
    license          => undef,  # license key from Microsoft. The value is ignored for SQL Express and for the Evaluation edition
    license_type     => 'Evaluation', # Possible Values: Evaluation, MSDN, Volume, Retail
    sa_password      => undef, # If provided, SQL Server will be installed with Windows and SQL authentication.
    source           => undef, # specifies the path of the ISO containing the SQL Server installation
  }
}
