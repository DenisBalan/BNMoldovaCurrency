function Get-BNMConfig {
    <#
        .SYNOPSIS
        Get the default configuration for BNM.

        .DESCRIPTION
        Get the default configuration for Banca Nationala of Moldova.

        .EXAMPLE
        Get-BNMConfig
    #>

    [CmdletBinding()]
    Param()

    try {
        Write-Verbose -Message 'Getting content of config.json and returning as a PSCustomObject.'
        $config = Get-Content -Path "$PSScriptRoot\config.json" -ErrorAction 'Stop' | ConvertFrom-Json
        
        $map = $config.bnm.params |% {
            $_.Psobject.Members | where-object membertype -like 'noteproperty';
        }
        $map |
            where-object value -match '^\$' |
                ForEach-Object { $_.value = Invoke-Expression $($_.value) }
        
        # idea from https://www.powershellmagazine.com/2019/06/14/pstip-a-better-way-to-generate-http-query-strings-in-powershell/
        # Create a http name value collection from an empty string
        $nvCollection = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
     
        $map | ForEach-Object { $nvCollection.Add($_.name, $_.value) }
        
        # Build the uri
        $uriRequest = [System.UriBuilder]$config.bnm.endPoint
        $uriRequest.Query = $nvCollection.ToString()
        
        return $uriRequest.Uri.OriginalString
    } catch {
        throw "Can't find the JSON configuration file. Use 'Set-BNMConfig' to create one."
    }
}