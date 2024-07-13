
# 予測を非表示
Set-PSReadLineOption -PredictionSource None

# --- scoop below --- #
# scoop-completion
Import-Module "$($(Get-Item $(Get-Command scoop.ps1).Path).Directory.Parent.FullName)\modules\scoop-completion"

# oh-my-posh
oh-my-posh init pwsh --config $HOME\scoop\apps\oh-my-posh\current\themes\stelbent-compact.minimal.omp.json | Invoke-Expression

# posh-git
Import-Module posh-git
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# terminal-icons
Import-Module Terminal-Icons
# --- scoop above --- #

# alias
Set-Alias touch New-Item
Remove-Item alias:rm -Force
function rm() { Remove-Item -Recurse -Force $args }
