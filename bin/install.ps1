
$dotfiles = $HOME\dotfiles

function make_link {
    param (
        [string]$value,
        [string]$path
    )
    if (Test-Path $path) {
        Move-Item -Path $path $Destination $backup
    }
    New-Item -ItemType SymbolicLink -Value $val -Path $path
}

# vscode
$local_vscode = $HOME\scoop\persist\vscode\data\user-data\User
make_link $dotfiles\vscode\settings.json $local_vscode\settings.json
make_link $dotfiles\vscode\snippets $local_vscode\snippets

# vim
make_link $dotfiles\vim\vimfiles\vimrc $HOME\vimfiles\vimrc

#latex
make_link $dotfiles\latex\.latexmkrc $HOME\.latexmkrc

