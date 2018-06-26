#region Header
using module ..\..\..\release\PowerStigConvert\PowerStigConvert.psd1
. $PSScriptRoot\..\..\helper.ps1
#endregion Header
#region Test Setup
$registriesToTest = @(
    @{
        Hive                        = 'HKEY_LOCAL_MACHINE'
        Path                        = '\Software\Policies\Microsoft\WindowsMediaPlayer'
        OrganizationValueRequired   = 'False'
        OrganizationValueTestString = ''
        ValueData                   = '1'
        ValueName                   = 'GroupPrivacyAcceptance'
        ValueType                   = 'DWORD'
        Ensure = 'Present'
        CheckContent                = 'Windows Media Player is not installed by default.  If it is not installed, this is NA.
        
                  If the following registry value does not exist or is not configured as specified, this is a finding:
        
                  Registry Hive: HKEY_LOCAL_MACHINE
                  Registry Path: \Software\Policies\Microsoft\WindowsMediaPlayer\
        
                  Value Name: GroupPrivacyAcceptance
        
                  Type: REG_DWORD
                  Value: 1'
    },
    @{
        Hive = 'HKEY_LOCAL_MACHINE'
        Path = '\System\CurrentControlSet\Services\W32Time\Config'
        OrganizationValueRequired = 'True'
        OrganizationValueTestString = "{0} -match '2|3'"
        ValueData = $null
        ValueName = 'EventLogFlags'
        ValueType = 'DWORD'
        Ensure = 'Present'
        CheckContent = 'Verify logging is configured to capture time source switches.
        
                  If the Windows Time Service is used, verify the following registry value.  If it is not configured as specified, this is a finding.
        
                  Registry Hive: HKEY_LOCAL_MACHINE
                  Registry Path: \System\CurrentControlSet\Services\W32Time\Config\
        
                  Value Name: EventLogFlags
        
                  Type: REG_DWORD
                  Value: 2 or 3
        
                  If another time synchronization tool is used, review the available configuration options and logs.  If the tool has time source logging capability and it is not enabled, this is a finding.'
    },
    @{
        Hive = 'HKEY_LOCAL_MACHINE'
        Path = '\System\CurrentControlSet\Control\Session Manager\Subsystems'
        OrganizationValueRequired = 'False'
        OrganizationValueTestString = ''
        ValueData = ''
        ValueName = 'Optional'
        ValueType = 'MultiString'
        Ensure = 'Present'
        CheckContent = 'If the following registry value does not exist or is not configured as specified, this is a finding:
        
                  Registry Hive: HKEY_LOCAL_MACHINE
                  Registry Path: \System\CurrentControlSet\Control\Session Manager\Subsystems\
        
                  Value Name: Optional
        
                  Value Type: REG_MULTI_SZ
                  Value: (Blank)'
    },
    @{
        Hive = 'HKEY_LOCAL_MACHINE'
        Path = '\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
        OrganizationValueRequired = 'True'
        OrganizationValueTestString = "{0} -le '5'"
        ValueData = $null
        ValueName = 'ScreenSaverGracePeriod'
        ValueType = 'String'
        Ensure = 'Present'
        CheckContent = 'If the following registry value does not exist or is not configured as specified, this is a finding:
        
                  Registry Hive: HKEY_LOCAL_MACHINE
                  Registry Path: \Software\Microsoft\Windows NT\CurrentVersion\Winlogon\
        
                  Value Name: ScreenSaverGracePeriod
        
                  Value Type: REG_SZ
                  Value: 5 (or less)'
    },
    @{
        Hive = 'HKEY_LOCAL_MACHINE'
        Path = '\System\CurrentControlSet\Control\Lsa\MSV1_0'
        OrganizationValueRequired = 'False'
        OrganizationValueTestString = ''
        ValueData = '537395200'
        ValueName = 'NTLMMinServerSec'
        ValueType                   = 'DWORD'
        Ensure = 'Present'
        CheckContent = 'If the following registry value does not exist or is not configured as specified, this is a finding:
        
                  Registry Hive: HKEY_LOCAL_MACHINE
                  Registry Path: \System\CurrentControlSet\Control\Lsa\MSV1_0\
        
                  Value Name: NTLMMinServerSec
        
                  Value Type: REG_DWORD
                  Value: 0x20080000 (537395200)'
    }
)
#endregion Test Setup
#region Tests
Describe "Registry basic settings conversion" {

    foreach ($registry in $registriesToTest)
    {
        [xml] $StigRule = Get-TestStigRule -CheckContent $registry.CheckContent -XccdfTitle Windows
        $TestFile = Join-Path -Path $TestDrive -ChildPath 'TextData.xml'
        $StigRule.Save( $TestFile )
        $rule = ConvertFrom-StigXccdf -Path $TestFile

        It "Should return an RegistryRule Object" {
            $rule.GetType() | Should Be 'RegistryRule'
        }
        It "Should extract the correct key" {
            $rule.key | Should Be $($registry.Hive + $registry.Path)
        }
        It "Should extract the correct value name" {
            $rule.valueName | Should Be $registry.ValueName
        }
        It "Should extract the correct value data" {
            $rule.valueData | Should Be $registry.ValueData
        }
        It "Should extract the correct value type" {
            $rule.valueType | Should Be $registry.ValueType
        }
        It "Should set the ensure value" {
            $rule.Ensure | Should Be $registry.Ensure
        }
        It "Should set OrganizationValueRequired to true" {
            $rule.OrganizationValueRequired | Should Be $registry.OrganizationValueRequired
        }
        It 'Should Set the status to pass' {
            $rule.conversionstatus | Should Be 'pass'
        }
    }
}
#endregion Tests
