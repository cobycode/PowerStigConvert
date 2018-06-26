# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Header
using module ..\common\enum.psm1
using module .\StigClass.psm1
. $PSScriptRoot\..\common\data.ps1
#endregion
#region Class Definition
Class WindowsFeatureRule : STIG
{
    [string]
    $FeatureName

    [string]
    $InstallState

    # Constructor
    WindowsFeatureRule ( [xml.xmlelement] $StigRule )
    {
        $this.InvokeClass($StigRule)
    }

    # Methods
    [void] SetFeatureName ()
    {
        $thisFeatureName = Get-WindowsFeatureName -CheckContent $this.RawString

        if ( -not $this.SetStatus( $thisFeatureName ) )
        {
            $this.set_FeatureName( $thisFeatureName )
        }
    }

    [void] SetFeatureInstallState ()
    {
        $thisInstallState = Get-FeatureInstallState -CheckContent $this.RawString

        if ( -not $this.SetStatus( $thisInstallState ) )
        {
            $this.set_InstallState( $thisInstallState )
        }
    }

    static [bool] HasMultipleRules ( [string] $FeatureName )
    {
        return ( Test-MultipleWindowsFeatureRule -FeatureName $FeatureName )
    }

    static [string[]] SplitMultipleRules ( [string] $FeatureName )
    {
        return ( Split-WindowsFeatureRule -FeatureName $FeatureName )
    }
}
#endregion
#region Method Functions
<#
    .SYNOPSIS
        Retreives the WindowsFeature name from the check-content element in the xccdf

    .PARAMETER CheckContent
        Specifies the check-content element in the xccdf
#>
function Get-WindowsFeatureName
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $CheckContent
    )

    Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
    $windowsFeatureName = @()
    try
    {
        switch ($CheckContent)
        {
            { $PSItem -match $script:RegularExpression.FeatureNameEquals }
            {
                $matches = $CheckContent | Select-String -Pattern $script:RegularExpression.FeatureNameEquals
                $windowsFeatureName += ( $matches.Matches.Value -replace 'FeatureName\s-eq' ).Trim()
            }
            { $PSItem -match $script:RegularExpression.FeatureNameSpaceColon }
            {
                $matches = $CheckContent | Select-String -Pattern $script:RegularExpression.FeatureNameSpaceColon -AllMatches
                $windowsFeatureName += ( $matches.Matches.Value -replace 'FeatureName\s\:' ).Trim()
            }
            { $PSItem -match $script:RegularExpression.IfTheApplicationExists -and $PSItem -notmatch 'telnet' }
            {
                $matches = $CheckContent | Select-String -Pattern $script:RegularExpression.IfTheApplicationExists
                $windowsFeatureName += (($matches.Matches.Value | Select-String -Pattern $script:RegularExpression.textBetweenQuotes).Matches.Value -replace '"').Trim()
            }
            { $PSItem -match 'telnet' }
            {
                $windowsFeatureName += 'TelnetClient'
            }
            { $PSItem -match $script:RegularExpression.WebDavPublishingFeature }
            {
                $windowsFeatureName += 'Web-DAV-Publishing'
            }
            { $PSItem -match $script:RegularExpression.SimpleTCP }
            {
                $windowsFeatureName += 'SimpleTCP'
            }
            { $PSItem -match $script:RegularExpression.IISHostableWebCore }
            {
                $windowsFeatureName += 'IIS-HostableWebCore'
            }
            { $PSItem -match $script:RegularExpression.IISWebserver }
            {
                $windowsFeatureName += 'IIS-WebServer'
            }
        }
    }
    catch
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] WindowsOptionalFeature : Not Found"
        return $null
    }
    return ($windowsFeatureName -join ',')
}

<#
    .SYNOPSIS
        Retreives the WindowsFeature InstallState from the check-content element in the xccdf

    .PARAMETER CheckContent
        Specifies the check-content element in the xccdf
#>
function Get-FeatureInstallState
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $CheckContent
    )

    switch ($CheckContent)
    {
        <#
            Currently ALL WindowsFeatureRules referenced in any of the STIGs will be uninstalled (Absent)
            so the default is Absent. When a STIG rule states a WindowsFeature is to be installed (Present)
            we can add the logic here.
        #>
        { $PSItem -eq $false }
        {
            return [ensure]::Present
        }
        default
        {
            [ensure]::Absent
        }
    }
}

<#
    .SYNOPSIS
        Test if the check-content contains WindowsFeatures to install/uninstall.

    .PARAMETER CheckContent
        Specifies the check-content element in the xccdf
#>
function Test-MultipleWindowsFeatureRule
{
    [CmdletBinding()]
    [OutputType([bool])]
    Param
    (
        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]
        $FeatureName
    )

    if ( $FeatureName -match ',')
    {
        return $true
    }
    return $false
}

<#
    .SYNOPSIS
        Consumes a list of mitigation targets seperated by a comma and outputs an array

    .PARAMETER FeatureName
        A list of comma seperate WindowsFeature names
#>
function Split-WindowsFeatureRule
{
    [CmdletBinding()]
    [OutputType([array])]
    Param
    (
        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]
        $FeatureName
    )

    return ( $FeatureName -split ',' )
}
#endregion
