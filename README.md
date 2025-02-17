# Powershell BNMoldovaCurrency module

Module that extracts information from National Bank of Moldova (Banca Națională a Moldovei - BNM) about today’s exchange rate for foreign currencies for integrating into application backends, excel sheets, and more

more info in blogpost: https://denis.md/create-powershell-module.html

![image](https://github.com/user-attachments/assets/ff538b83-72fe-4dae-8e8e-2806f6417630)


## Know your tools

Building a module nowadays without additional tools, ie "from scratch" is a messy task, below are several tools that helps automate steps.

| Tool        | Used for           | Stage  |
| ------------- |:-------------:| -----:|
| [Plaster]      | module templating      |   develop |
| [BuildHelpers] | dependency restorer      |    build |
| [InvokeBuild] | build automation      |    build |
| [PSScriptAnalyzer]      | static code checker | testing |
| [Pester]      | testing and mocking | testing |
| [Polaris] | HTTP framework for PowerShell      |    testing |
| [PSDeploy] | deployment to AppVeyor      |    deploy |

## Exported functions


| Name | Synopsis | Description
| ------------- | --- | ----- |
| Get-BNMConfig | Get the default configuration for BNM. | Get the default configuration for Banca Nationala of Moldova. |
| Get-BNMCurrency | Gets BNM currency for specified date. | Invokes HTTP GET method to the BNM server for reading exchange rates based on configuration file. |
| Save-BNMCurrency | Saves BNM currency for specified date. | Uses Get-BNMCurrency to get data. |
| Set-BNMConfig | Set the default configuration for Banca Nationala of Moldova. | Set the default configuration for BNM server. |
