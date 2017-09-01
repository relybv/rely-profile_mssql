# == Class profile_mssql::install
#
# This class is called from profile_mssql for install.
#
class profile_mssql::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }
  notice("Running with media $profile_mssql::media")
  # install network time sync
  include 'winntp'

  # init all new disks
  exec { 'format_all_raw':
    command   => file('profile_mssql/format_all_raw.ps1'),
    provider  => powershell,
    logoutput => true,
    before    => Pget['download mssql'],
  }

  pget { 'download mssql':
    source => $::profile_mssql::params::isourl,
    target => 'C:\windows\temp',
  }

  windows_isos{'SQLServer':
    ensure   => present,
    isopath  => 'C:\\windows\\temp\\en_sql_server_2012_enterprise_edition_with_service_pack_2_x64_dvd_4685849.iso',
    require  => Pget['download mssql'],
  }

  # install sql server
  User {
    ensure   => present,
    before => Exec['install_mssql2012'],
  }

  user { 'SQLAGTSVC':
    comment  => 'SQL 2012 Agent Service.',
    password => $::profile_mssql::agtsvcpassword,
  }
  user { 'SQLASSVC':
    comment  => 'SQL 2012 Analysis Service.',
    password => $::profile_mssql::assvcpassword,
  }
  user { 'SQLRSSVC':
    comment  => 'SQL 2012 Report Service.',
    password => $::profile_mssql::rssvcpassword,
  }
  user { 'SQLSVC':
    comment  => 'SQL 2012 Service.',
    groups   => 'Administrators',
    password => $::profile_mssql::sqlsvcpassword,
  }

  file { 'C:\sql2012install.ini':
    content => template('profile_mssql/config.ini.erb'),
  }

  dism { ['NetFx3ServerFeatures', 'NetFx3']:
    ensure => present,
  }

  exec { 'install_mssql2012':
    command   => "${profile_mssql::media}\\setup.exe /Action=Install /IACCEPTSQLSERVERLICENSETERMS /QS /HIDECONSOLE /CONFIGURATIONFILE=C:\\sql2012install.ini /SAPWD=\"${::profile_mssql::sapwd}\" /SQLSVCPASSWORD=\"${::profile_mssql::sqlsvcpassword}\" /AGTSVCPASSWORD=\"${::profile_mssql::agtsvcpassword}\" /ASSVCPASSWORD=\"${::profile_mssql::assvcpassword}\" /RSSVCPASSWORD=\"${::profile_mssql::rssvcpassword}\"",
    cwd       => $profile_mssql::media,
    path      => $profile_mssql::media,
    logoutput => true,
    creates   => $::profile_mssql::instancedir,
    timeout   => 1200,
    require   => [ File['C:\sql2012install.ini'], Windows_isos['SQLServer'], Dism['NetFx3'] ],
  }
}
