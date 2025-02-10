$vscode_dir = $MyInvocation.MyCommand.Path
while ((Split-Path $vscode_dir -Leaf) -ne "vscode") {
    $vscode_dir = Split-Path $vscode_dir -Parent
}

# pull extensions
cat "${vscode_dir}/extensions" | ForEach-Object {
    code --install-extension $_
}

# push extensions
code --list-extensions > "${vscode_dir}/extensions"
