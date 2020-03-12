$Script:ModuleRoot = Resolve-Path "$PSScriptRoot\..\output\$Env:BHProjectName"
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ConfigPath = Join-Path -Path $Script:ModuleRoot -ChildPath "config.json"


$InitPolaris = {
    function InitPolaris {
        Stop-Polaris
        Clear-Polaris
        New-PolarisGetRoute -Path "/get-xml" -Scriptblock {
            $Response.Send(@"
<?xml version="1.0" encoding="UTF-8"?>
    <ValCurs name="Cursul oficial de schimb">
      <Valute>
        <NumCode>978</NumCode>
        <CharCode>EUR</CharCode>
        <Nominal>1</Nominal>
        <Name>Euro</Name>
        <Value>19.6052</Value>
      </Valute>
    </ValCurs>
"@)
        }
        Start-Polaris -Port 8844
    }
    InitPolaris
    while (1) { Start-Sleep 1; }
}

function Reset-Real-Configuration {
    $config = @{
        bnm = @{
            endPoint = "https://bnm.md/ro/official_exchange_rates"; 
            params=@(
                @{get_xml=1}; 
                @{date="`$(get-date -f 'dd.MM.yyyy')"}
            )
        }
    }
    $config | ConvertTo-Json -Depth 99 | Set-Content -Path $Script:ConfigPath
}

function Reset-Proxy-Configuration {
    $config = @{
        bnm = @{
            endPoint = "http://localhost:8844/get-xml";
            params=@(
            )
        }
    }
    $config | ConvertTo-Json -Depth 99 | Set-Content -Path $Script:ConfigPath
}

$global:job = $null;
Describe "Get-BNMCurrency (Public)" {
    Context "Get-BNMCurrency (Proxied - Polaris)" {
        BeforeAll { Reset-Proxy-Configuration; $global:job = Start-Job -ScriptBlock $InitPolaris }
        AfterAll { $global:job | Stop-Job; $global:job | Remove-Job }
        It "Should connect to proxy" {
            { Get-BNMCurrency } | Should -Not -Throw
        }
        It "Should return one record from proxy" {
            $data = Get-BNMCurrency;

            $count = ($data | Measure-Object).Count
            $count | Should -Be 1
        }
        It "Should return correct data from proxy" {
            $data = Get-BNMCurrency;

            $code = ($data | Select-Object -First 1).CharCode
            $code | Should -Be 'EUR'
        }
    }
    Context "Get-BNMCurrency (Unmocked)" {
        BeforeAll { Reset-Real-Configuration }

        It "Should connect to BNM" {
            { Get-BNMCurrency } | Should -Not -Throw
        }
        It "Should return at least one record from BNM" {
            $data = Get-BNMCurrency;

            $count = ($data | Measure-Object).Count
            $count | Should -BeGreaterThan 1
        }
        It "Should contain EUR from BNM" {
            $data = Get-BNMCurrency;

            $code = ($data | foreach-object { $_.charcode })
            $code | Should -Contain 'EUR'
        }
        It "Should contain USD from BNM" {
            $data = Get-BNMCurrency;

            $code = ($data | foreach-object { $_.charcode })
            $code | Should -Contain 'USD'
        }
    }
}