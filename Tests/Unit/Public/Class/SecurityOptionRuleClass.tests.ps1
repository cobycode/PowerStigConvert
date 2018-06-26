#region Header
using module ..\..\..\..\src\public\class\SecurityOptionRuleClass.psm1
. $PSScriptRoot\..\..\..\helper.ps1
$ruleClassName = ($MyInvocation.MyCommand.Name -Split '\.')[0]
#endregion
#region Setup Tests
$rule = [SecurityOptionRule]::new( (Get-TestStigRule -ReturnGroupOnly) )

$stringsToTest = @(
    @{
        Name  = 'Accounts: Guest account status'
        Value = 'Disabled'
        OrganizationValueRequired   = $false
        OrganizationValueTestString = ''
        CheckContent = 'Verify the effective setting in Local Group Policy Editor.
        Run "gpedit.msc".
        
        Navigate to Local Computer Policy -&gt; Computer Configuration -&gt; Windows Settings -&gt; Security Settings -&gt; Local Policies -&gt; Security Options.
        
        If the value for "Accounts: Guest account status" is not set to "Disabled", this is a finding.'
    },
    @{
        Name  = 'Accounts: Rename guest account'
        Value = 'Guest'
        OrganizationValueRequired   = $true
        OrganizationValueTestString = "{0} -notmatch 'Guest'"
        CheckContent = 'Verify the effective setting in Local Group Policy Editor.
        Run "gpedit.msc".
        
        Navigate to Local Computer Policy -&gt; Computer Configuration -&gt; Windows Settings -&gt; Security Settings -&gt; Local Policies -&gt; Security Options.
        
        If the value for "Accounts: Rename guest account" is not set to a value other than "Guest", this is a finding.'
    },
    @{
        Name         = 'Network security: Force logoff when logon hours expire'
        Value        = 'Enabled'
        OrganizationValueRequired   = $false
        OrganizationValueTestString = ''
        CheckContent = 'Verify the effective setting in Local Group Policy Editor.
        Run "gpedit.msc".
        
        Navigate to Local Computer Policy -&gt; Computer Configuration -&gt; Windows Settings -&gt; Security Settings -&gt; Local Policies -&gt; Security Options.
        
        If the value for "Network security: Force logoff when logon hours expire" is not set to "Enabled", this is a finding.'
    }
)
#endregion
#region Class Tests
Describe "$ruleClassName Child Class" {

    Context 'Base Class' {
        
        It "Shoud have a BaseType of STIG" {
            $rule.GetType().BaseType.ToString() | Should Be 'STIG'
        }
    }

    Context 'Class Properties' {

        $classProperties = @('OptionName', 'OptionValue')

        foreach ( $property in $classProperties )
        {
            It "Should have a property named '$property'" {
                ( $rule | Get-Member -Name $property ).Name | Should Be $property
            }
        }
    }

    Context 'Class Methods' {

        $classMethods = @( 'SetOptionName', 'TestOptionValueForRange', 'SetOptionValue', 
            'SetOptionValueRange' )

        foreach ( $method in $classMethods )
        {
            It "Should have a method named '$method'" {
                ( $rule | Get-Member -Name $method ).Name | Should Be $method
            }
        }

        # If new methods are added this will catch them so test coverage can be added
        It "Should not have more methods than are tested" {
            $memberPlanned = Get-StigBaseMethods -ChildClassMethodNames $classMethods
            $memberActual = ( $rule | Get-Member -MemberType Method ).Name
            $compare = Compare-Object -ReferenceObject $memberActual -DifferenceObject $memberPlanned
            $compare.Count | Should Be 0
        }
    }
}
#endregion
#region Method Tests
Describe 'Get-SecurityOptionName' {

    foreach ( $string in $stringsToTest )
    {
        It "Should return '$($string.Name)'" {
            $checkContent = Split-TestStrings -CheckContent $string.CheckContent
            Get-SecurityOptionName -CheckContent $checkContent | Should Be $string.Name
        }
    }
}

Describe 'Get-SecurityOptionValue' {

    foreach ( $string in $stringsToTest )
    {
        It "Should return '$($string.Value)'" {
            $checkContent = Split-TestStrings -CheckContent $string.CheckContent
            Get-SecurityOptionValue -CheckContent $checkContent | Should Be $string.Value
        }
    }
}
#endregion
