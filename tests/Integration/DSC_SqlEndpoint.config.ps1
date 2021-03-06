#region HEADER
# Integration Test Config Template Version: 1.2.0
#endregion

$configFile = [System.IO.Path]::ChangeExtension($MyInvocation.MyCommand.Path, 'json')
if (Test-Path -Path $configFile)
{
    <#
        Allows reading the configuration data from a JSON file,
        for real testing scenarios outside of the CI.
    #>
    $ConfigurationData = Get-Content -Path $configFile | ConvertFrom-Json
}
else
{
    $ConfigurationData = @{
        AllNodes = @(
            @{
                NodeName             = 'localhost'
                ServerName           = $env:COMPUTERNAME
                InstanceName         = 'DSCSQLTEST'

                EndpointName         = 'HADR'
                Port                 = 5023
                IpAddress            = '0.0.0.0'
                Owner                = 'sa'

                CertificateFile      = $env:DscPublicCertificatePath
            }
        )
    }
}

<#
    .SYNOPSIS
        Configuration to ensure present and specify all the parameters
#>
Configuration DSC_SqlEndpoint_Add_Config
{
    Import-DscResource -ModuleName 'SqlServerDsc'

    node $AllNodes.NodeName
    {
        SqlEndpoint 'Integration_Test'
        {
            Ensure               = 'Present'

            EndpointName         = $Node.EndpointName
            EndpointType         = 'DatabaseMirroring'
            Port                 = $Node.Port
            IpAddress            = $Node.IpAddress
            Owner                = $Node.Owner
            State                = 'Started'

            ServerName           = $Node.ServerName
            InstanceName         = $Node.InstanceName
        }
    }
}

<#
    .SYNOPSIS
        Configuration to ensure Absent and specify all the parameters
#>
Configuration DSC_SqlEndpoint_Remove_Config
{
    Import-DscResource -ModuleName 'SqlServerDsc'

    node $AllNodes.NodeName
    {
        SqlEndpoint 'Integration_Test'
        {
            Ensure               = 'Absent'

            EndpointName         = $Node.EndpointName
            EndpointType         = 'DatabaseMirroring'

            ServerName           = $Node.ServerName
            InstanceName         = $Node.InstanceName
        }
    }
}


