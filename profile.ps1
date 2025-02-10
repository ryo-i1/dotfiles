# hide prediction
Set-PSReadLineOption -PredictionSource None
# diaplay all suggestions
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

#
# alias
#
if (-not (Test-Path alias:touch)) { Set-Alias touch New-Item }
if (Test-Path alias:rm) { Remove-Item alias:rm -Force }
function rm() { Remove-Item -Recurse -Force $args }


#
# scoop-completion
#
Import-Module "$($(Get-Item $(Get-Command scoop.ps1).Path).Directory.Parent.FullName)\modules\scoop-completion"


#
# oh-my-posh
#
oh-my-posh init pwsh --config $HOME\scoop\apps\oh-my-posh\current\themes\stelbent-compact.minimal.omp.json | Invoke-Expression


#
# posh-git
#
Import-Module posh-git

# $time = Get-Date -f 'HH:mm:ss'

# # display home dir as ~ in prompt
# $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
# # order : [git status] then [current path]
# $GitPromptSettings.DefaultPromptWriteStatusFirst = $false

# # prefix
# $GitPromptSettings.DefaultPromptPrefix.Text = "`n"
# # before suffix
# $GitPromptSettings.DefaultPromptBeforeSuffix.Text = " | ${time}`n"
# $GitPromptSettings.DefaultPromptBeforeSuffix.ForegroundColor = [ConsoleColor]::DarkCyan
# # suffix
# $GitPromptSettings.DefaultPromptSuffix = "$('$' * ($nestedPromptLevel + 1)) "


#
# terminal-icons
#
Import-Module Terminal-Icons
