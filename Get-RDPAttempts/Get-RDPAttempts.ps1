<#
.DESCRIPTION
Searches the WinEvent logs for any RDP attempts.

Requires
Configuration/Policies/WindowsSettings/Security Settings/Advanced Audit Policy Configuration/AuditPolicies/Audit Credential Validation set to Failures.
And monitor Event ID 4776.
#>

#Requires -RunAsAdministrator

function Get-LogonAttempts {
    $logontypes = @{
            '2' = 'Interactive'
            '3' = 'Network'
            '4' = 'Batch'
            '5' = 'Service'
            '7' = 'Unlock'
            '8' = 'NetworkCleartext'
            '9' = 'NewCredentials'
            '10' = 'RemoteInteractive'
            '11' = 'CachedInteractive'
            }

    write-host('This might take awhile')
    #id 4624: successful
    #id 4625: unsuccessful
    $results = Get-WinEvent -FilterHashtable @{logname="Security";id=@(4625, 4624)} | 
                Where-Object {$_.Properties.Value[8] -ne 5} |
                Select-Object Id,
                    @{label='TimeCreated';expression={$_.TimeCreated.ToString("yyyy-M-d HH:mm:ss")}},
                    @{label='Username';expression={$_.Properties.Value[5]}},
                    @{label='Domain';expression={$_.Properties.Value[6]}},
                    @{label='Hostname';expression={$_.Properties.Value[11]}},
                    @{label='LogonType';expression={$logontypes["$($_.Properties.Value[8])"]}},
                    @{label='IP';expression={$_.Properties.Value[18]}}
                #Where-0bject {$_.Username -ne 'SYSTEM'}
    $results | Format-Table -Property *

}

Get-LogonAttempts