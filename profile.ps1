
# 予測を非表示
Set-PSReadLineOption -PredictionSource None

# scoop-completion
Import-Module "$($(Get-Item $(Get-Command scoop.ps1).Path).Directory.Parent.FullName)\modules\scoop-completion"

