<#
    .DESCRIPTION
        This example shows how to ensure that the SQL Agent
        failsafe operator FailsafeOp does not exist.
#>

Configuration Example
{
    Import-DscResource -ModuleName 'SqlServerCustomDsc'

    node localhost
    {
        SqlAgentFailsafe 'Remove_FailsafeOp'
        {
            Ensure       = 'Absent'
            Name         = 'FailsafeOp'
            ServerName   = 'TestServer'
            InstanceName = 'MSSQLServer'
        }
    }
}
