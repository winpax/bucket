$dir = "$PSScriptRoot/../bucket"
$readme = "$PSScriptRoot/../README.md"
$readme_template = "$PSScriptRoot/../README.template.md"

Remove-Item $readme
$file_contents = Get-Content $readme_template

$items = ''

ForEach ($child in (Get-ChildItem $dir).Name)
{
    $content = Get-Content ([String]::Format('{0}/{1}', $dir, $child)) | ConvertFrom-Json

    $table_contents = [String]::Format("|{0}|{1}|{2}|`n", $child -replace '.json', $content.description, $content.version)

    $items += $table_contents
}

$file_contents = $file_contents.Replace('| %app-name% | %app-description% | %app-version% |', $items)

Set-Content $readme $file_contents
