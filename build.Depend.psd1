@{
    PSDependOptions = @{
        Target    = '$DependencyFolder/_build_dependencies_/'
        AddToPath = $true
    }
    InvokeBuild     = '5.4.1'
    PSDeploy        = '0.2.5'
    BuildHelpers    = '1.1.4'
    Pester          = '4.3.1'
    PSScriptAnalyzer = '1.18.3'
    Polaris         = '0.2.0'
}