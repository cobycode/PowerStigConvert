#region Header
. $PSScriptRoot\..\..\..\helper.ps1
[string] $sut = $MyInvocation.MyCommand.Path -replace '\\tests\\','\src\' `
                                             -replace '\.tests','' `
                                             -replace '\\unit\\','\' `
                                             -replace 'ps1', 'psm1'
Import-Module $sut -Force
#endregion
#region Test Setup
$checkContent = 'Verify the effective setting in Local Group Policy Editor.
Run "gpedit.msc".

Navigate to Local Computer Policy -&gt; Computer Configuration -&gt; Windows Settings -&gt; Security Settings -&gt; Local Policies -&gt; User Rights Assignment.

If any accounts or groups (to include administrators), are granted the "Act as part of the operating system" user right, this is a finding.'
#endregion
#region Tests
Describe "ConvertTo-UserRightRule" {
    
    <#
        This function can't really be unit tested, since the call cannot be mocked by pester, so 
        the only thing we can really do at this point is to verify that it returns the correct object. 
    #>
    $stigRule = Get-TestStigRule -CheckContent $checkContent -ReturnGroupOnly
    $rule = ConvertTo-UserRightRule -StigRule $stigRule
    
    It "Should return an UserRightRule object" {
        $rule.GetType() | Should Be 'UserRightRule'
    }
}
#endregion
