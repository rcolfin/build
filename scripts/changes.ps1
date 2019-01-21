 param (
    [Parameter(Mandatory=$true)][string]$hash1,
    [Parameter(Mandatory=$true)][string]$hash2,
    [string]$path
 )

$startLocation = Get-Location
$path = If ([System.String]::IsNullOrWhiteSpace($path)) { $startLocation } `
        else { If ([System.IO.Path]::IsPathRooted($path)) { [System.IO.Path]::GetFullPath($path) } else { [System.IO.Path]::Combine($startLocation, $path) } };
Set-Location -Path $path;
$path = Get-Location
$gitRoot = cmd.exe /c "git rev-parse --show-toplevel";
$gitRoot = [System.IO.Path]::GetFullPath($gitRoot);

$cmd="git diff --stat ${hash1} ${hash2} --name-only `"$path`"";
$output = cmd.exe /c "$cmd";
$output = $output | Out-String -Stream `
                  | Where-Object {![System.String]::IsNullOrWhiteSpace($_) -and $_.Contains("/")} `
                  | foreach-object {[System.IO.Path]::GetDirectoryName([System.IO.Path]::GetFullPath([System.IO.Path]::Combine($gitRoot, $_)))} `
                  | foreach-object { $_.SubString([System.Math]::Min($path.Length + 1, $_.Length)) -replace "\\.*", "" } `
                  | Where-Object {![System.String]::IsNullOrWhiteSpace($_)} `
                  | foreach-object {[System.IO.Path]::GetFullPath([System.IO.Path]::Combine($path, $_))} `
                  | Where-Object {[System.IO.Directory]::Exists($_)} `
                  | Sort `
                  | Get-Unique;

echo $output

Set-Location -Path $startLocation;