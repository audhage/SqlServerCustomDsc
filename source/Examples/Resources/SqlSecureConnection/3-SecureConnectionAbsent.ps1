<#
    .DESCRIPTION
        This example performs a standard Sql encryption setup. Forcing all connections to be encrypted.
#>
Configuration Example
{
    Import-DscResource -ModuleName 'SqlServerCustomDsc'

    node localhost
    {
        SqlSecureConnection 'SecureConnectionAbsent'
        {
            InstanceName    = 'MSSQLSERVER'
            Thumbprint      = ''
            Ensure          = 'Absent'
            ServiceAccount  = 'SqlSvc'
        }
    }
}
