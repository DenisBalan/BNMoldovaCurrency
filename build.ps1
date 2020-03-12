[CmdletBinding()]
Param (
    $Task = 'Default',
    $VersionIncrement = 'Patch'
)

function Install-PSDepend {

    $PSDependVersion = '0.2.3'
    if (!(Get-InstalledModule -Name 'PSDepend' -RequiredVersion $PSDependVersion -ErrorAction 'SilentlyContinue')) {
        Install-Module -Name 'PSDepend' -RequiredVersion $PSDependVersion -Force -Scope 'CurrentUser'
    }
    Import-Module -Name 'PSDepend' -RequiredVersion $PSDependVersion
    Invoke-PSDepend -Path "$PSScriptRoot\build.Depend.psd1" -Install -Import -Force
}

switch ($Task) {
    'Build' {
        Write-Output 'Starting build of BNMoldovaCurrency'
        Install-PSDepend
        Invoke-Build -Task $Task -Result InvokeBuildResult -VersionIncrement $VersionIncrement
        break
    }
    'Test' {
        Write-Output 'Running Pester tests for BNMoldovaCurrency'
        Invoke-Build -Task $Task -Result InvokeBuildResult
        break
    }
    'Deploy' {
        Write-Output 'Deploying BNMoldovaCurrency'
        Invoke-Build -Task $Task -Result InvokeBuildResult
        break
    }
    'Default' {
        Write-Output 'Building and testing BNMoldovaCurrency'
        Install-PSDepend
        Invoke-Build -Task $Task -Result InvokeBuildResult -VersionIncrement $VersionIncrement
        break
    }
    Default {
        throw [System.ArgumentException]::new("Unknown task type: $Task")
    }
}
if ($InvokeBuildResult.Errors) {
    $Result.Tasks | Where-Object { $_.Error } | ForEach-Object { 
        "Task '$($_.Name)' at $($_.InvocationInfo.ScriptName):$($_.InvocationInfo.ScriptLineNumber)"
        $_.Error
    }

    exit 1
}