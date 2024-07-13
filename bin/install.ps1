
$dotfiles = "$HOME\dotfiles"
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

#latex
make_link "$dotfiles\latex\.latexmkrc" "$HOME\.latexmkrc"
