# working directory
$dotfiles = $MyInvocation.MyCommand.Path
while ((Split-Path $dotfiles -Leaf) -ne "dotfiles") {
    $dotfiles = Split-Path $dotfiles -Parent
}

$backup = "${dotfiles}\backup"
function make_link {
    param (
        [string]$value,
        [string]$path
    )

    # make backup if file exists
    if (Test-Path $path) {
        if ((Get-Item $path).LinkType -eq "SymbolicLink") {
            return
        }
        Move-Item -Path $path -Destination $backup
    }

    # make link
    New-Item -ItemType SymbolicLink -Value $value -Path $path
}


# profile
make_link "${dotfiles}\profile.ps1" "$PROFILE"


#
# scoop
#
$jsonfile = "${dotfiles}\scoop_list.json"
$data = Get-Content $jsonfile | ConvertFrom-Json

$sp_export = scoop export
$data_installed = $sp_export | ConvertFrom-Json
$installed_buckets = $data_installed.buckets | ForEach-Object { $_.Name }
$installed_apps = $data_installed.apps | ForEach-Object { $_.Name }

# install buckets
ForEach ($bucket in $data.scoop.buckets) {
    if ($installed_buckets -notcontains $bucket) {
        Write-Output "Install bucket: ${bucket}"
        scoop bucket add $bucket
    }
}

# install apps
ForEach ($app in $data.scoop.apps) {
    if ($installed_apps -notcontains $app) {
        Write-Output "Install app: ${app}"
        scoop install $app
    }
}

# scoop alias
$sp_help = scoop help
$sp_cmd = $sp_help -split '\r?\n' | ForEach-Object {
    if ($_ -match 'Command=(\S+);') {
        $matches[1]
    }
}
# upgrade
if ($sp_cmd -notcontains 'upgrade') {
    scoop alias add upgrade 'scoop update; scoop update *; scoop cache rm *; scoop cleanup *' 'Update all apps.'
}
# reinstall
if ($sp_cmd -notcontains 'reinstall') {
    scoop alias add reinstall 'scoop uninstall $args[0]; scoop install $args[0]' 'Reinstall an app.'
}


#
# vscode
#
$local_vscode = "$HOME\scoop\persist\vscode\data\user-data\User"
make_link "${dotfiles}\vscode\settings.json" "${local_vscode}\settings.json"
make_link "${dotfiles}\vscode\snippets" "${local_vscode}\snippets"

# sync extensions
& "${dotfiles}\vscode\sync.ps1"


#
# vim
#
make_link "${dotfiles}\vim\vimrc" "$HOME\vimfiles\vimrc"

# Vundle
$bundle = "$HOME\vimfiles\bundle"
if (-not (Test-Path $bundle)) {
    mkdir $bundle
}
$Vundle = "${bundle}\Vundle.vim"
if (-not (Test-Path $Vundle)) {
    git clone "https://github.com/VundleVim/Vundle.vim.git" $Vundle
}


#
# latex
#
make_link "${dotfiles}\latex\.latexmkrc" "$HOME\.latexmkrc"
