$vscode_dir = $MyInvocation.MyCommand.Path
while ((Split-Path $vscode_dir -Leaf) -ne "vscode") {
    $vscode_dir = Split-Path $vscode_dir -Parent
}

# pull extensions
$vscode_installed_ext = code --list-extensions
cat "${vscode_dir}/extensions" | ForEach-Object {
    if ($vscode_installed_ext -notcontains $_) {
        code --install-extension $_
    }
}

# push extensions
code --list-extensions > "${vscode_dir}/extensions"
