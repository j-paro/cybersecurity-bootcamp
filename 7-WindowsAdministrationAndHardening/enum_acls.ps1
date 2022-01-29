$directory=Get-Location | Get-ChildItem

foreach ($item in $directory) {
    Get-Acl $item
}
