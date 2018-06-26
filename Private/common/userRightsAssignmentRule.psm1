# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Header
using module ..\..\public\Class\UserRightsAssignmentRuleClass.psm1
using module ..\..\public\common\enum.psm1
using module .\helperFunctions.psm1
#endregion Header
#region Main Functions
<#
    .SYNOPSIS
        Converts rule from STIG Xccdf to a UserRightRule
#>
function ConvertTo-UserRightRule
{
    [CmdletBinding()]
    [OutputType([UserRightRule[]])]
    Param
    (
        [parameter(Mandatory = $true)]
        [xml.xmlelement]
        $StigRule
    )

    Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
    $userRightRules = @()

    if ( [UserRightRule]::HasMultipleRules( $StigRule.rule.Check.'check-content' ) )
    {
        [string[]] $splitRules = [UserRightRule]::SplitMultipleRules( $StigRule.rule.Check.'check-content' )

        [int] $byte = 97
        [string] $ruleId = $StigRule.id
        foreach ( $splitRule in $splitRules )
        {
            $StigRule.id = "$($ruleId).$([CHAR][BYTE]$byte)"
            $StigRule.rule.Check.'check-content' = $splitRule
            $userRightRules += New-UserRightRule -StigRule $StigRule
            $byte++
        }
    }
    else
    {
        $userRightRules += New-UserRightRule -StigRule $StigRule
    }

    return $userRightRules
}
#endregion Main Functions
#region Support Function
function New-UserRightRule
{
    [CmdletBinding()]
    [OutputType([UserRightRule])]
    Param
    (
        [parameter(Mandatory = $true)]
        [xml.xmlelement]
        $StigRule
    )

    $userRightRule = [UserRightRule]::New( $StigRule )
    $userRightRule.SetDisplayName()
    $userRightRule.SetConstant()
    $userRightRule.SetIdentity()
    $userRightRule.SetForce()
    $userRightRule.SetStigRuleResource()

    if ( $userRightRule.IsDuplicateRule( $Global:STIGSettings ) )
    {
        $userRightRule.SetDuplicateTitle()
    }

    if ( Test-ExistingRule -RuleCollection $Global:STIGSettings -NewRule $userRightRule )
    {
        $newId = Get-AvailableId -Id $userRightRule.Id
        $userRightRule.set_id( $newId )
    }

    return $userRightRule
}
#endregion Support Functions
