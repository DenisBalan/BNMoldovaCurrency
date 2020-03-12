function Save-BNMCurrency {
    <#
        .SYNOPSIS
        Saves BNM currency for specified date.

        .DESCRIPTION
        Uses Get-BNMCurrency to get data.
        
        .EXAMPLE
        Save-BNMCurrency
        Saves into default filename.
        
        .EXAMPLE
        Save-BNMCurrency -Filename today.csv
        Saves into specified filename.
    #>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Filename
    )
    
    Get-BNMCurrency | ConvertTo-Csv -NoTypeInformation | Set-Content $Filename

}