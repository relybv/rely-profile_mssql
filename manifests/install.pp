# == Class profile_mssql::install
#
# This class is called from profile_mssql for install.
#
class profile_mssql::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  class { '::sqlserver':
  }
}
