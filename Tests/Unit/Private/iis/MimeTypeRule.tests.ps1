#region Header
[string] $sut = $MyInvocation.MyCommand.Path -replace '\\tests\\', '\src\' `
    -replace '\.tests', '' `
    -replace '\\unit\\', '\' `
    -replace 'ps1', 'psm1'
# load the helper script and system under test
. $PSScriptRoot\..\..\..\helper.ps1
Import-Module $sut
#endregion header

#region Test setup
$checkContent = 'Follow the procedures below for each site hosted on the IIS 8.5 web server:

Open the IIS 8.5 Manager.

Click on the IIS 8.5 site.

Under IIS, double-click the MIME Types icon.

From the "Group by:" drop-down list, select "Content Type".

From the list of extensions under "Application", verify MIME types for OS shell program extensions have been removed, to include at a minimum, the following extensions:

.exe

If any OS shell MIME types are configured, this is a finding.'

#endregion Test Setup

#region Function Tests

Describe "ConvertTo-MimeTypeRule" {
    $stigRule = Get-TestStigRule -CheckContent $checkContent -ReturnGroupOnly
    $rule = ConvertTo-MimeTypeRule -StigRule $stigRule

    It "Should return an MimeTypeRule object" {
        $rule.GetType() | Should Be 'MimeTypeRule'
    }
}
#endregion Function Tests
