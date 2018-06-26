# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Data
# These are the registry strings that are not able to be automatically extracted from the xccdf.
$LegalNoticeText = "You are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only.
By using this IS (which includes any device attached to this IS), you consent to the following conditions:
-The USG routinely intercepts and monitors communications on this IS for purposes including, but not limited to, penetration testing, COMSEC monitoring, network operations and defense, personnel misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations.
-At any time, the USG may inspect and seize data stored on this IS.
-Communications using, or data stored on, this IS are not private, are subject to routine monitoring, interception, and search, and may be disclosed or used for any USG-authorized purpose.
-This IS includes security measures (e.g., authentication and access controls) to protect USG interests--not for your personal benefit or privacy.
-Notwithstanding the above, using this IS does not constitute consent to PM, LE or CI investigative searching or monitoring of the content of privileged communications, or work product, related to personal representation or services by attorneys, psychotherapists, or clergy, and their assistants. Such communications and work product are private and confidential. See User Agreement for details."
$LegalNoticeCaption = 'DoD Notice and Consent Banner'
$SupportedEncryptionTypes = '0'
$smb1FeatureName = 'FS-SMB1'
#endregion
#region Main Functions
<#
    .SYNOPSIS
        Accepts defeat in that the STIG string data for a select few checks are too unwieldy to parse
        properly. The OVAL data does not provide much more help in a few of the cases, so the STIG Id's
        for these checks are hardcoded here to force a fixed value to be returned.

    .PARAMETER StigId
        The Stig ID to check for a fixed string

    .NOTES
#>
function Test-ValueDataIsHardCoded
{
    [CmdletBinding()]
    [OutputType([bool])]
    Param
    (
        [parameter(Mandatory = $true)]
        [string]
        $StigId
    )

    $stigIds = @(
        'V-1089', # Windows Server - Legal Notice Display
        'V-63675', # Windows Client - Legal Notice Display
        'V-26359', # Windows Server - Legal Banner Dialog Box Title
        'V-63681', # Windows Client - Legal Banner Dialog Box Title
        'V-21954', # Windows Server - Kerberos Supported Encryption Types
        'V-73805'  # Windows Server - Disable SMB1 'V-70639' is on the client, but the WindowsFeature
        # resource does not use the Get-WindowsOptionalFeature cmdlet so this has to stay manual on
        # the desktop for now or else we have to move everythign to a script resource.
    )

    if ($stigIds -contains $StigId)
    {
        Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] HardCoded : $true"
        $true
    }
    else
    {
        Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] HardCoded : $false"
        $false
    }
}

<#
    .SYNOPSIS
        Returns the hard coded string for the given Stig ID

    .PARAMETER StigId
        The Stig ID to check for a fixed string

    .NOTES
 #>
function Get-HardCodedString
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [parameter(Mandatory = $true)]
        [string]
        $StigId
    )

    Switch ($StigId)
    {
        {$PSItem -match 'V-(1089|63675)'}
        {
            Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] LegalNotice : $true"
            $hardCodedString = $legalNoticeText
            continue
        }
        {$PSItem -match 'V-(26359|63681)'}
        {
            Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] LegalCaption : $true"
            $hardCodedString = $legalNoticeCaption
            continue
        }

        {$PSItem -match 'V-21954'}
        {
            Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] SupportedEncryptionTypes : $true"
            $hardCodedString = $supportedEncryptionTypes
            continue
        }

        {$PSItem -match 'V-73805'}
        {
            Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] SMB1: $true"
            $hardCodedString = $smb1FeatureName
            continue
        }

    }

    return $hardCodedString
}

<#
    .SYNOPSIS
        Determines if the organization value test string is in the short list of STIGs that
        cannot be reasonably parsed

    .PARAMETER StigId
        The Stig ID to check for a fixed string
 #>
 function Test-IsHardCodedOrganizationValueTestString
{
    [CmdletBinding()]
    [OutputType([bool])]
    Param
    (
        [parameter(Mandatory = $true)]
        [string]
        $StigId
    )

    $stigIds = @(
        'V-3472.b', # Windows Time Service - Configure NTP Client
        'V-8322.b', # Time Synchronization
        'V-14235', # UAC - Admin Elevation Prompt
        'V-26359' # Windows Server - Legal Banner Dialog Box Title
    )

    if ($stigIds -contains $StigId)
    {
        Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] HardCoded : $true"
        $true
    }
    else
    {
        Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] HardCoded : $false"
        $false
    }
}

<#
    .SYNOPSIS
        Returns the hard coded organization value test string for the given Stig ID

    .PARAMETER StigId
        The Stig ID to check for a fixed string
 #>
 function Get-HardCodedOrganizationValueTestString
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [parameter(Mandatory = $true)]
        [string]
        $StigId
    )

    Switch ($StigId)
    {
        {$PSItem -match 'V-3472.b'}
        {
            $hardCodedString = "'{0}' -notmatch 'time.windows.com'"
            continue
        }
        {$PSItem -match 'V-8322.b'}
        {
            $hardCodedString = "'{0}' -match '^(NoSync|NTP|NT5DS|AllSync)$'"
            continue
        }
        {$PSItem -match 'V-14235'}
        {
            $hardCodedString = "'{0}' -le '4'"
            continue
        }
        {$PSItem -match 'V-26359'}
        {
            $hardCodedString = "'{0}' -match '^(DoD Notice and Consent Banner|US Department of Defense Warning Statement)$'"
            continue
        }
    }

    return $hardCodedString
}
#endregion
