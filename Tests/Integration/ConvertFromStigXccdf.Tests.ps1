# Use this script to verify PowerStigConvert code updates do not impact functional integrity

#region Header
using module ..\..\release\PowerStigConvert\PowerStigConvert.psd1
#endregion Header

$filePath = "$PSScriptRoot\xccdf"

# Building the baseline rule set values
$stigs = @{
    'U_Windows_2012_and_2012_R2_MS_STIG_V2R9_Manual-xccdf.xml'    = @{
        AccountPolicyRule            = 9
        AuditPolicyRule              = 34
        DnsServerRootHintRule        = $null
        DnsServerSettingRule         = $null
        DocumentRule                 = 12
        GroupRule                    = $null
        IisLoggingRule               = $null
        ManualRule                   = 38
        MimeTypeRule                 = $null
        PermissionRule               = 11
        ProcessMitigationRule        = $null
        RegistryRule                 = 205
        SecurityOptionRule           = 5
        ServiceRule                  = 7
        SqlScriptQueryRule           = $null
        UserRightRule                = 37
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = $null
        WinEventLogRule              = $null
        WindowsFeatureRule           = 1
        WmiRule                      = 2
    }
    'U_Windows_2012_and_2012_R2_MS_STIG_V2R12_Manual-xccdf.xml'   = @{
        AccountPolicyRule            = 9
        AuditPolicyRule              = 31
        DnsServerRootHintRule        = $null
        DnsServerSettingRule         = $null
        DocumentRule                 = 13
        IisLoggingRule               = $null
        ManualRule                   = 37
        MimeTypeRule                 = $null
        PermissionRule               = 11
        ProcessMitigationRule        = $null
        RegistryRule                 = 203
        SecurityOptionRule           = 5
        ServiceRule                  = 7
        SqlScriptQueryRule           = $null
        UserRightRule                = 34
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = $null
        WinEventLogRule              = $null
        WindowsFeatureRule           = 1
        WmiRule                      = 2
    }
    'U_Windows_2012_and_2012_R2_DC_STIG_V2R9_Manual-xccdf.xml'    = @{
        AccountPolicyRule            = 9
        AuditPolicyRule              = 38
        DnsServerRootHintRule        = $null
        DnsServerSettingRule         = $null
        DocumentRule                 = 16
        GroupRule                    = $null
        IisLoggingRule               = $null
        ManualRule                   = 53
        MimeTypeRule                 = $null
        PermissionRule               = 18
        ProcessMitigationRule        = $null
        RegistryRule                 = 207
        SecurityOptionRule           = 5
        ServiceRule                  = 16
        SqlScriptQueryRule           = $null
        UserRightRule                = 39
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = $null
        WinEventLogRule              = $null
        WindowsFeatureRule           = 1
        WmiRule                      = 2
    }
    'U_Windows_2012_and_2012_R2_DC_STIG_V2R12_Manual-xccdf.xml'   = @{
        AccountPolicyRule            = 9
        AuditPolicyRule              = 36
        DnsServerRootHintRule        = $n
        DnsServerSettingRule         = $null
        DocumentRule                 = 17
        IisLoggingRule               = $null
        ManualRule                   = 51
        MimeTypeRule                 = $null
        PermissionRule               = 18
        ProcessMitigationRule        = $null
        RegistryRule                 = 205
        SecurityOptionRule           = 5
        ServiceRule                  = 16
        SqlScriptQueryRule           = $null
        UserRightRule                = 36
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = $null
        WinEventLogRule              = $null
        WindowsFeatureRule           = 1
        WmiRule                      = 2
    }
    'U_MS_Windows_2012_Server_DNS_STIG_V1R7_Manual-xccdf.xml'     = @{
        AccountPolicyRule            = $null
        AuditPolicyRule              = $null
        DnsServerRootHintRule        = 1
        DnsServerSettingRule         = 2
        DocumentRule                 = 19
        GroupRule                    = $null
        IisLoggingRule               = $null
        ManualRule                   = 64
        MimeTypeRule                 = $null
        PermissionRule               = 2
        ProcessMitigationRule        = $null
        RegistryRule                 = $null
        SecurityOptionRule           = $null
        ServiceRule                  = $null
        SqlScriptQueryRule           = $null
        UserRightRule                = 4
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = $null
        WinEventLogRule              = 1
        WindowsFeatureRule           = $null
        WmiRule                      = $null
    }
    'U_MS_Windows_2012_Server_DNS_STIG_V1R9_Manual-xccdf.xml'     = @{
        AccountPolicyRule            = $null
        AuditPolicyRule              = $null
        DnsServerRootHintRule        = 1
        DnsServerSettingRule         = 2
        DocumentRule                 = 19
        GroupRule                    = $null
        IisLoggingRule               = $null
        ManualRule                   = 64
        MimeTypeRule                 = $null
        PermissionRule               = 2
        ProcessMitigationRule        = $null
        RegistryRule                 = $null
        SecurityOptionRule           = $null
        ServiceRule                  = $null
        SqlScriptQueryRule           = $null
        UserRightRule                = 4
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = $null
        WinEventLogRule              = 1
        WindowsFeatureRule           = $null
        WmiRule                      = $null
    }
    'U_MS_IE11_STIG_V1R13_Manual-xccdf.xml'                       = @{
        AccountPolicyRule            = $null
        AuditPolicyRule              = $null
        DnsServerRootHintRule        = $null
        DnsServerSettingRule         = $null
        DocumentRule                 = $null
        GroupRule                    = $null
        IisLoggingRule               = $null
        ManualRule                   = $null
        MimeTypeRule                 = $null
        PermissionRule               = $null
        ProcessMitigationRule        = $null
        RegistryRule                 = 140
        SecurityOptionRule           = $null
        ServiceRule                  = $null
        SqlScriptQueryRule           = $null
        UserRightRule                = $null
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = $null
        WinEventLogRule              = $null
        WindowsFeatureRule           = $null
        WmiRule                      = $null
    }
    'U_MS_IE11_STIG_V1R15_Manual-xccdf.xml'                       = @{
        AccountPolicyRule            = $null
        AuditPolicyRule              = $null
        DnsServerRootHintRule        = $null
        DnsServerSettingRule         = $null
        DocumentRule                 = $null
        GroupRule                    = $null
        IisLoggingRule               = $null
        ManualRule                   = $null
        MimeTypeRule                 = $null
        PermissionRule               = $null
        ProcessMitigationRule        = $null
        RegistryRule                 = 140
        SecurityOptionRule           = $null
        ServiceRule                  = $null
        SqlScriptQueryRule           = $null
        UserRightRule                = $null
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = $null
        WinEventLogRule              = $null
        WindowsFeatureRule           = $null
        WmiRule                      = $null
    }
    'U_Windows_Firewall_STIG_V1R6_Manual-xccdf.xml'               = @{
        AccountPolicyRule            = $null
        AuditPolicyRule              = $null
        DnsServerRootHintRule        = $null
        DnsServerSettingRule         = $null
        DocumentRule                 = $null
        GroupRule                    = $null
        IisLoggingRule               = $null
        ManualRule                   = 1
        MimeTypeRule                 = $null
        PermissionRule               = $null
        ProcessMitigationRule        = $null
        RegistryRule                 = 38
        SecurityOptionRule           = $null
        ServiceRule                  = $null
        SqlScriptQueryRule           = $null
        UserRightRule                = $null
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = $null
        WinEventLogRule              = $null
        WindowsFeatureRule           = $null
        WmiRule                      = $null
    }
    'U_Windows_10_STIG_V1R12_Manual-xccdf.xml'                    = @{
        AccountPolicyRule            = 9
        AuditPolicyRule              = 38
        DnsServerRootHintRule        = $null
        DnsServerSettingRule         = $null
        DocumentRule                 = 4
        GroupRule                    = 1
        IisLoggingRule               = $null
        ManualRule                   = 27
        MimeTypeRule                 = $null
        PermissionRule               = 9
        ProcessMitigationRule        = 31
        RegistryRule                 = 140
        SecurityOptionRule           = 6
        ServiceRule                  = 2
        SqlScriptQueryRule           = $null
        UserRightRule                = 30
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = $null
        WinEventLogRule              = $null
        WindowsFeatureRule           = 9
        WmiRule                      = 1
    }
    'U_IIS_8-5_Site_STIG_V1R2_Manual-xccdf.xml'                   = @{
        AccountPolicyRule            = $null
        AuditPolicyRule              = $null
        DnsServerRootHintRule        = $null
        DnsServerSettingRule         = $null
        DocumentRule                 = 18
        GroupRule                    = $null
        IisLoggingRule               = 5
        ManualRule                   = 14
        MimeTypeRule                 = 5
        PermissionRule               = $null
        ProcessMitigationRule        = $null
        RegistryRule                 = $null
        SecurityOptionRule           = $null
        ServiceRule                  = $null
        SqlScriptQueryRule           = $null
        UserRightRule                = $null
        WebAppPoolRule               = 5
        WebConfigurationPropertyRule = 17
        WinEventLogRule              = $null
        WindowsFeatureRule           = 1
        WmiRule                      = $null
    }
    'U_SQL_Server_2012_Instance_STIG_V1R16_Manual-xccdf.xml'      = @{
        AccountPolicyRule            = $null
        AuditPolicyRule              = $null
        DnsServerRootHintRule        = $null
        DnsServerSettingRule         = $null
        DocumentRule                 = 45
        IisLoggingRule               = $null
        ManualRule                   = 76
        MimeTypeRule                 = $null
        PermissionRule               = $null
        ProcessMitigationRule        = $null
        RegistryRule                 = $null
        SecurityOptionRule           = $null
        ServiceRule                  = $null
        SqlScriptQueryRule           = 32
        UserRightRule                = $null
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = $null
        WinEventLogRule              = $null
        WindowsFeatureRule           = $null
        WmiRule                      = $null
    }
    'U_Microsoft_DotNet_Framework_4-0_STIG_V1R4_Manual-xccdf.xml' = @{
        AccountPolicyRule            = $null
        AuditPolicyRule              = $null
        DnsServerRootHintRule        = $null
        DnsServerSettingRule         = $null
        DocumentRule                 = 3
        IisLoggingRule               = $null
        ManualRule                   = 11
        MimeTypeRule                 = $null
        PermissionRule               = $null
        ProcessMitigationRule        = $null
        RegistryRule                 = 1
        SecurityOptionRule           = $null
        ServiceRule                  = $null
        SqlScriptQueryRule           = $null
        UserRightRule                = $null
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = $null
        WinEventLogRule              = $null
        WindowsFeatureRule           = $null
        WmiRule                      = $null
    }
    'U_SQL_Server_2012_Database_STIG_V1R17_Manual-xccdf.xml'      = @{
        AccountPolicyRule            = $null
        AuditPolicyRule              = $null
        DnsServerRootHintRule        = $null
        DnsServerSettingRule         = $null
        DocumentRule                 = 13
        IisLoggingRule               = $null
        ManualRule                   = 14
        MimeTypeRule                 = $null
        PermissionRule               = $null
        ProcessMitigationRule        = $null
        RegistryRule                 = $null
        SecurityOptionRule           = $null
        ServiceRule                  = $null
        SqlScriptQueryRule           = 1
        UserRightRule                = $null
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = $null
        WinEventLogRule              = $null
        WindowsFeatureRule           = $null
        WmiRule                      = $null
    }
    'U_IIS_8-5_Server_STIG_V1R3_Manual-xccdf.xml'                 = @{
        AccountPolicyRule            = $null
        AuditPolicyRule              = $null
        DnsServerRootHintRule        = $null
        DnsServerSettingRule         = $null
        DocumentRule                 = 16
        IisLoggingRule               = 5
        ManualRule                   = 16
        MimeTypeRule                 = 5
        PermissionRule               = 1
        ProcessMitigationRule        = $null
        RegistryRule                 = 5
        SecurityOptionRule           = $null
        ServiceRule                  = $null
        SqlScriptRule                = $null
        UserRightRule                = $null
        WebAppPoolRule               = $null
        WebConfigurationPropertyRule = 10
        WinEventLogRule              = $null
        WindowsFeatureRule           = 1
        WmiRule                      = $null
    }
}

# Verify conversion report rule set values are equal to baseline values
Describe 'STIG Conversion' {

    foreach ($file in $stigs.keys)
    {
        $conversionReport = Get-ConversionReport -Path "$filePath\$file"
        $ruleConversion = $stigs.item($file)

        Context "$file" {

            foreach ($key in $ruleConversion.keys)
            {
                $keyValue = $ruleConversion.$key

                It "$key should return $keyValue rules" {
                    ($conversionReport | Where-Object {$_.type -eq $key}).conversionpass | Should be $keyValue
                }
            }
        }
    }
}
