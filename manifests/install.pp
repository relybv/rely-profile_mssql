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
    password => $::agtsvcpassword,
  }
  user { 'SQLASSVC':
    comment  => 'SQL 2012 Analysis Service.',
    password => $assvcpassword,
  }
  user { 'SQLRSSVC':
    comment  => 'SQL 2012 Report Service.',
    password => $rssvcpassword,
  }
  user { 'SQLSVC':
    comment  => 'SQL 2012 Service.',
    groups   => 'Administrators',
    password => $sqlsvcpassword,
  }

  file { 'C:\sql2012install.ini':
    content => template('profile_mssql/config.ini.erb'),
  }

  dism { 'NetFx3':
    ensure => present,
  }

  exec { 'install_mssql2012':
    command   => "${media}\\setup.exe /Action=Install /IACCEPTSQLSERVERLICENSETERMS /Q /HIDECONSOLE /CONFIGURATIONFILE=C:\\sql2012install.ini /SAPWD=\"${sapwd}\" /SQLSVCPASSWORD=\"${sqlsvcpassword}\" /AGTSVCPASSWORD=\"${agtsvcpassword}\" /ASSVCPASSWORD=\"${assvcpassword}\" /RSSVCPASSWORD=\"${rssvcpassword}\"",
    cwd       => $media,
    path      => $media,
    logoutput => true,
    creates   => $instancedir,
    timeout   => 1200,
    require   => [ File['C:\sql2012install.ini'],
                   Dism['NetFx3'] ],
  }
}
