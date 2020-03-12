function Set-BNMConfig {
    <#
        .SYNOPSIS
        Set the default configuration for Banca Nationala of Moldova.

        .DESCRIPTION
        Set the default configuration for BNM server. Convert parameter values to object and write to the JSON configuration file.

        .PARAMETER Endpoint
        The URI endpoint that will be utilized.

        .PARAMETER Params
        The params that will be appended to the URI.
        
        .EXAMPLE
        Set-BNMConfig -Endpoint "https://bnm.md/ro/official_exchange_rates" -Params "@{get_xml = 1; date = '01.01.2020'}"
        Sets the default addr to "bnm.md" with query param "get_xml=1&date=01.01.2020".

        .EXAMPLE
        Set-BNMConfig -Endpoint "https://localhost/get_currency"
        Used in case of proxy-ing bnm.md results via nginx or alternative proxy.
        Also can be used in test environments.
        Sets the default addr to "localhost" without query param.

    #>

    [CmdletBinding()]
    Param(
        [ValidateNotNullOrEmpty()]
        [String]
        $Endpoint,
        $Params
    )

    try {
        Write-Verbose -Message 'Trying Get-BNMConfig before Set-BNMConfig.'
        $config = Get-Content -Path "$PSScriptRoot\config.json" -ErrorAction 'Stop' |
            ConvertFrom-Json
        Write-Verbose -Message 'Stored config.json found.'
    } catch {
        Write-Verbose -Message 'No configuration found - starting with default configuration.'
        $config = @{
            bnm = @{
                endPoint = "https://bnm.md/ro/official_exchange_rates"; 
                params=@(
                    @{get_xml=1}; 
                    @{date="`$(get-date -f 'dd.MM.yyyy')"}
                )
            }
        }
    }

    if ($Endpoint) {$config.bnm.endpoint = $Endpoint}
    if ($Params) {$config.bnm.params = $Params}

    Write-Verbose -Message 'Setting config.json.'
    $config |
        ConvertTo-Json -Depth 99 |
            Set-Content -Path "$PSScriptRoot\config.json"
}