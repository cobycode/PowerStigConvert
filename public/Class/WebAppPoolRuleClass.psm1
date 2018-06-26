# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Header
using module .\StigClass.psm1
using module ..\common\enum.psm1
#endregion
#region Class Definition
Class WebAppPoolRule : STIG
{
    [string] $Key
    [string] $Value

    # Constructors
    WebAppPoolRule ( [xml.xmlelement] $StigRule )
    {
        $this.InvokeClass( $StigRule )
    }

    [void] SetKeyValuePair ( )
    {
        $thisKeyValuePair = Get-KeyValuePair -CheckContent $this.SplitCheckContent

        if ( -not $this.SetStatus( $thisKeyValuePair ) )
        {
            $this.set_Key( $thisKeyValuePair.Key )
            $this.set_Value( $thisKeyValuePair.Value )
        }
    }

    [Boolean] IsOrganizationalSetting ( )
    {
        if ( -not [String]::IsNullOrEmpty( $this.key ) -and [String]::IsNullOrEmpty( $this.value ) )
        {
            return $true
        }
        else
        {
           return $false
        }
    }

    [void] SetOrganizationValueTestString ( )
    {
        $thisOrganizationValueTestString = Get-OrganizationValueTestString -Key $this.key

        if ( -not $this.SetStatus( $thisOrganizationValueTestString ) )
        {
            $this.set_OrganizationValueTestString( $thisOrganizationValueTestString )
            $this.set_OrganizationValueRequired( $true )
        }
    }
}
#endregion
#region Method Functions
<#
.SYNOPSIS
    Returns the key and value properties for the STIG rule.

.Parameter CheckContent
    An array of the raw string data taken from the STIG setting.
#>
function Get-KeyValuePair
{
    [CmdletBinding()]
    [OutputType([object])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [psobject]
        $CheckContent
    )

    switch ( $CheckContent )
    {
        { $PsItem -match 'Idle Time-out' }
        {
            $key = 'idleTimeout'
            $value = $null
        }
        { $PsItem -match 'Queue Length' }
        {
            $key = 'queueLength'
            $value = $null
        }
        { $PsItem -match 'Ping Enabled' }
        {
            $key = 'pingingEnabled'
            $value = '$true'
        }
        { $PsItem -match 'Rapid Fail Protection:Enabled' }
        {
            $key = 'rapidFailProtection'
            $value = '$true'
        }
        { $PsItem -match 'Failure Interval' }
        {
            $key = 'rapidFailProtectionInterval'
            $value = $null
        }
    }

    if ($null -ne $key)
    {
        Write-Verbose -Message $("[$($MyInvocation.MyCommand.Name)] Found Key: {0}, value: {1}" -f $key, $value)

        return @{
            key   = $key
            value = $value
        }
    }
    else
    {
        Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] No Key or Value found"
        return $null
    }
}

<#
.SYNOPSIS
    Takes the key property from a WebAppPoolrule to determine the Organizational value
    test string to return.

.PARAMETER Key
    Key property from the WebAppPoolrule.
#>
function Get-OrganizationValueTestString
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Key
    )

    switch ( $Key )
    {
        { $PsItem -match 'idleTimeout' }
        {
            return "[TimeSpan]{0} -le [TimeSpan]'00:20:00'"
        }
        { $PsItem -match 'queueLength' }
        {
            return "{0} -le 1000"
        }
        { $PsItem -match 'rapidFailProtectionInterval' }
        {
            return "[TimeSpan]{0} -le [TimeSpan]'00:05:00'"
        }
        default
        {
            return $null
        }
    }
}
#endregion
