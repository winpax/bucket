$dir = "$PSScriptRoot/../bucket"
$readme = "$PSScriptRoot/../README.md"
$readme_template = "$PSScriptRoot/../README.template.md"

Remove-Item $readme
Copy-Item $readme_template $readme

ForEach ($child in (Get-ChildItem $dir).Name)
{
    $content = Get-Content ([String]::Format('{0}/{1}', $dir, $child)) | ConvertFrom-Json

    $table_contents = [String]::Format('|{0}|{1}|{2}|', $child -replace '.json', $content.description, $content.version)

    Add-Content $readme $table_contents
}