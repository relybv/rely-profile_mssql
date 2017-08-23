# == Class profile_mssql::config
#
# This class is called from profile_mssql for service config.
#
class profile_mssql::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }
}
