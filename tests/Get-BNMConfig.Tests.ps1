$Script:ModuleRoot = Resolve-Path "$PSScriptRoot\..\output\$Env:BHProjectName"
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ConfigPath = Join-Path -Path $Script:ModuleRoot -ChildPath "config.json"

Describe "Get-BNMConfig (Public)" {
    Context "Get-BNMConfig" {
        It "Should return a valid object with expected items" {
            $params = @(@{a = 1}, @{b = 2});
            Set-BNMConfig -Endpoint 'https://bnm.md/' -Params $params
            $result = Get-BNMConfig
            $result | Should -Be 'https://bnm.md:443/?a=1&b=2'
        }

        It "Should return a valid url with scripting param" {
            $params = @(@{a = 1}, @{b = '$(echo 2)'});
            Set-BNMConfig -Endpoint 'https://bnm.md/' -Params $params
            $result = Get-BNMConfig
            $result | Should -Be 'https://bnm.md:443/?a=1&b=2'
        }

        It "Should throw if the expected file does not exist" {
            try {
                Rename-Item -Path $Script:ConfigPath -NewName "configrename.json" -Force
                {Get-BNMConfig} | Should -Throw
            }
            finally {
                Rename-Item -Path "$Script:ModuleRoot\configrename.json" -NewName "config.json" -Force
            }
        }
    }
}