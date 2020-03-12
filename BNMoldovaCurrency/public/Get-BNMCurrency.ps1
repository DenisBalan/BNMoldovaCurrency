function Get-BNMCurrency {
    <#
        .SYNOPSIS
        Gets BNM currency for specified date.

        .DESCRIPTION
        Invokes HTTP GET method to the BNM server for reading exchange rates based on configuration file.
        
        .EXAMPLE
        Get-BNMCurrency
        Returns whole list of available rates from Banca Nationala.

        .EXAMPLE        
        Get-BNMCurrency |? { CharCode -match 'EUR' }
        Returns data only for EURO currency.

        .EXAMPLE        
        Get-BNMCurrency |? { CharCode -match 'EUR' } |% Value
        Returns float value representing exchange rate in MDL (1 EUR = xx.xx MDL)

        .EXAMPLE
        Get-BNMCurrency |% CharCode
        Returns list of supported currencies.

        .EXAMPLE        
        Get-BNMCurrency | select CharCode, Value
        Returns a table representing a map from currency and value.
        
        .EXAMPLE        
        Get-BNMCurrency | select CharCode, Value | convertto-csv -notypeinformation | sc rates.csv
        Saves exchange rates into csv file.
    #>

    [CmdletBinding()]
    Param ()

    Write-Verbose -Message 'Starting Get-BNMCurrency.'

    $url = Get-BNMConfig -ErrorAction 'SilentlyContinue'
    
    $data = [xml] $(Invoke-RestMethod $url)
    
    $fname = "{0}_{1}.xml" -f $(New-TemporaryFile).FullName, $MyInvocation.MyCommand.Name;
    
    $data.Save($fname);

    $returnObj = $data.ValCurs.Valute;
    
    Write-Verbose -Message 'Exiting Get-BNMCurrency.'

    return $returnObj
}