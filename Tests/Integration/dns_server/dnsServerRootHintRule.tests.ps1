#region Header
using module ..\..\..\release\PowerStigConvert\PowerStigConvert.psd1
. $PSScriptRoot\..\..\helper.ps1
#endregion Header
#region Test Setup
$rootHintsCheckContent = @'
Note: If the Windows DNS server is in the classified network, this check is Not Applicable.

Log on to the authoritative DNS server using the Domain Admin or Enterprise Admin account.

Press Windows Key + R, execute dnsmgmt.msc.

Right-click the DNS server, select Properties.

Select the "Root Hints" tab.

Verify the "Root Hints" is either empty or only has entries for internal zones under "Name servers:". All Internet root server entries must be removed.

If "Root Hints" is not empty and the entries on the "Root Hints" tab under "Name servers:" are external to the local network, this is a finding.
'@

#endregion Test Setup
#region Tests
Describe "DnsServerRootHintRule conversion" {

    Context "Root hints" {
        [xml] $StigRule = Get-TestStigRule -CheckContent $rootHintsCheckContent -XccdfTitle 'Domain Name System'
        $TestFile = Join-Path -Path $TestDrive -ChildPath 'TextData.xml'
        $StigRule.Save( $TestFile )
        $rule = ConvertFrom-StigXccdf -Path $TestFile

        It "Should be a DnsServerRootHintRule" {
            $rule.GetType() | Should be 'DnsServerRootHintRule'
        }
        It 'Should have a HostName of $null' {
            $rule.HostName | Should Be '$null'
        }
        It 'Should have a IpAddress of $null' {
            $rule.IpAddress | Should Be '$null'
        }
        It "Should set the Conversion status to pass" {
            $rule.conversionstatus | Should be 'pass'
        }
    }
}
#endregion
