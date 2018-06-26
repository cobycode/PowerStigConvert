#region Header
using module ..\..\..\release\PowerStigConvert\PowerStigConvert.psd1
. $PSScriptRoot\..\..\helper.ps1
#endregion
#region Test Setup
$testStrings = @(
    @{
        FeatureName  = 'SMB1Protocol'
        InstallState = 'Absent'
        OrganizationValueRequired = $false
        CheckContent = 'This applies to Windows 2012 R2.
        
        Run "Windows PowerShell" with elevated privileges (run as administrator).
        Enter the following:
        Get-WindowsOptionalFeature -Online | Where FeatureName -eq SMB1Protocol
        
        If "State : Enabled" is returned, this is a finding.
        
        Alternately:
        Search for "Features".
        Select "Turn Windows features on or off".
        
        If "SMB 1.0/CIFS File Sharing Support" is selected, this is a finding.'
    }
)
#endregion
#region Tests
Describe "Windows Feature Conversion" {

    foreach ( $testString in $testStrings )
    {
        [xml] $StigRule = Get-TestStigRule -CheckContent $testString.CheckContent -XccdfTitle Windows
        $TestFile = Join-Path -Path $TestDrive -ChildPath 'TextData.xml'
        $StigRule.Save( $TestFile )
        $rule = ConvertFrom-StigXccdf -Path $TestFile

        It "Should return an WindowsFeatureRule Object" {
            $rule.GetType() | Should Be 'WindowsFeatureRule'
        }
        It "Should set Feature Name to '$($testString.FeatureName)'" {
            $rule.FeatureName | Should Be $testString.FeatureName
        }
        It "Should set Install State to '$($testString.InstallState)'" {
            $rule.InstallState | Should Be $testString.InstallState
        }
        It "Should set OrganizationValueRequired to $($testString.OrganizationValueRequired)" {
            $rule.OrganizationValueRequired | Should Be $testString.OrganizationValueRequired
        }
        It "Should set OrganizationValueTestString to $($testString.OrganizationValueTestString)" {
            $rule.OrganizationValueTestString | Should Be $testString.OrganizationValueTestString
        }
        It 'Should Set the status to pass' {
            $rule.conversionstatus | Should Be 'pass'
        }
    }
}
#endregion
