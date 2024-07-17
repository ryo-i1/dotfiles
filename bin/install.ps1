
$dotfiles = $MyInvocation.MyCommand.Path
while ((Split-Path $dotfiles -Leaf) -ne "dotfiles") {
    $dotfiles = Split-Path $dotfiles -Parent
}

$jsonfile = "$dotfiles\setup.json"
$data = Get-Content $jsonfile | ConvertFrom-Json

# scoop install
$sp_export = scoop export
$data_installed = $sp_export | ConvertFrom-Json

$installed_buckets = $data_installed.buckets | ForEach-Object { $_.Name }
$installed_apps = $data_installed.apps | ForEach-Object { $_.Name }

## buckets
ForEach ($bucket in $data.scoop.buckets) {
    if ($installed_buckets -notcontains $bucket) {
        Write-Output "Install bucket: $bucket"
        scoop bucket add $bucket
    }
}

## apps
ForEach ($app in $data.scoop.apps) {
    if ($installed_apps -notcontains $app) {
        Write-Output "Install app: $app"
        scoop install $app
    }
}


$backup = "$dotfiles\backup"

function make_link {
    param (
        [string]$value,
        [string]$path
    )

    # ファイルが存在する場合はバックアップを取る
    if (Test-Path $path) {
        # シンボリックファイルの場合は関数を抜ける
        if ((Get-Item $path).LinkType -eq "SymbolicLink") {
            return
        }
        Move-Item -Path $path -Destination $backup
    }

    # シンボリックリンクを作成
    New-Item -ItemType SymbolicLink -Value $value -Path $path
}

# profile
make_link "$dotfiles\profile.ps1" "$PROFILE"

# vscode
$local_vscode = "$HOME\scoop\persist\vscode\data\user-data\User"
make_link "$dotfiles\vscode\settings.json" "$local_vscode\settings.json"
make_link "$dotfiles\vscode\snippets" "$local_vscode\snippets"

# vim
make_link "$dotfiles\vim\_vimrc" "$HOME\_vimrc"
# Vundle
$bundle = "$HOME\.vim\bundle"
if (-not (Test-Path $bundle)) {
    mkdir $bundle
}
$Vundle = "$bundle\Vundle.vim"
if (-not (Test-Path $Vundle)) {
    git clone https://github.com/VundleVim/Vundle.vim.git $Vundle
}

# latex
make_link "$dotfiles\latex\.latexmkrc" "$HOME\.latexmkrc"


# scoop alias
$sp_help = scoop help
$sp_cmd = $sp_help -split '\r?\n' | ForEach-Object {
    if ($_ -match 'Name=(\S+);') {
        $matches[1]
    }
}

## upgrade
if ($sp_cmd -notcontains 'upgrade') {
    scoop alias add upgrade 'scoop update; scoop update *; scoop cache rm *; scoop cleanup *' 'Update all apps.'
}
## reinstall
if ($sp_cmd -notcontains 'reinstall') {
    scoop alias add reinstall 'scoop uninstall $args[0]; scoop install $args[0]' 'Reinstall an app.'
}
