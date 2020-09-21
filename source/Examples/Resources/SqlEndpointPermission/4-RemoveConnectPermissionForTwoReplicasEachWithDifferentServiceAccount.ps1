<#
    .DESCRIPTION
        This example will remove connect permission to both an Always On primary replica and an
        Always On secondary replica, and where each replica has a different SQL service account.
#>

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName        = '*'
            InstanceName = 'MSSQLSERVER'

            # Not recommended for production. Only set here to pass CI.
            PsDscAllowPlainTextPassword = $true
        },

        @{
            NodeName = 'SQLNODE01.company.local'
            Role     = 'PrimaryReplica'
        },

        @{
            NodeName = 'SQLNODE02.company.local'
            Role     = 'SecondaryReplica'
        }
    )
}

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $SqlAdministratorCredential,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $SqlServiceNode1Credential,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $SqlServiceNode2Credential
    )

    Import-DscResource -ModuleName 'SqlServerCustomDsc'

    node $AllNodes.Where{$_.Role -eq 'PrimaryReplica' }.NodeName
    {
        SqlEndpointPermission 'RemoveSQLConfigureEndpointPermissionPrimary'
        {
            Ensure               = 'Absent'
            ServerName           = $Node.NodeName
            InstanceName         = $Node.InstanceName
            Name                 = 'DefaultMirrorEndpoint'
            Principal            = $SqlServiceNode1Credential.UserName
            Permission           = 'CONNECT'

            PsDscRunAsCredential = $SqlAdministratorCredential
        }

        SqlEndpointPermission 'RemoveSQLConfigureEndpointPermissionSecondary'
        {
            Ensure               = 'Absent'
            ServerName           = $Node.NodeName
            InstanceName         = $Node.InstanceName
            Name                 = 'DefaultMirrorEndpoint'
            Principal            = $SqlServiceNode2Credential.UserName
            Permission           = 'CONNECT'

            PsDscRunAsCredential = $SqlAdministratorCredential
        }
    }

    Node $AllNodes.Where{ $_.Role -eq 'SecondaryReplica' }.NodeName
    {
        SqlEndpointPermission 'RemoveSQLConfigureEndpointPermissionPrimary'
        {
            Ensure               = 'Absent'
            ServerName           = $Node.NodeName
            InstanceName         = $Node.InstanceName
            Name                 = 'DefaultMirrorEndpoint'
            Principal            = $SqlServiceNode1Credential.UserName
            Permission           = 'CONNECT'

            PsDscRunAsCredential = $SqlAdministratorCredential
        }

        SqlEndpointPermission 'RemoveSQLConfigureEndpointPermissionSecondary'
        {
            Ensure               = 'Absent'
            ServerName           = $Node.NodeName
            InstanceName         = $Node.InstanceName
            Name                 = 'DefaultMirrorEndpoint'
            Principal            = $SqlServiceNode2Credential.UserName
            Permission           = 'CONNECT'

            PsDscRunAsCredential = $SqlAdministratorCredential
        }
    }
}
