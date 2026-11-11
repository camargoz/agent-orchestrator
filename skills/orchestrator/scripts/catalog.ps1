param(
    [string]$ProjectRoot = (Get-Location).Path
)

function Get-Frontmatter([string]$Path) {
    $lines = Get-Content -LiteralPath $Path -TotalCount 40
    $meta = @{}
    if ($lines.Count -eq 0 -or $lines[0].Trim() -ne '---') { return $meta }
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Trim() -eq '---') { break }
        if ($lines[$i] -match '^([A-Za-z_-]+):\s*(.*)$') { $meta[$matches[1]] = $matches[2].Trim() }
    }
    return $meta
}

$homeClaude = Join-Path $HOME '.claude'
$projClaude = Join-Path $ProjectRoot '.claude'

$sources = @(
    @{ Scope = 'projeto'; Base = $projClaude },
    @{ Scope = 'global';  Base = $homeClaude }
)

Write-Output '## Agentes'
foreach ($s in $sources) {
    $dir = Join-Path $s.Base 'agents'
    if (-not (Test-Path $dir)) { continue }
    Get-ChildItem -LiteralPath $dir -Filter '*.md' | ForEach-Object {
        $m = Get-Frontmatter $_.FullName
        $name = if ($m['name']) { $m['name'] } else { $_.BaseName }
        Write-Output ("- [{0}] {1} :: {2}  ({3})" -f $s.Scope, $name, $m['description'], $_.FullName)
    }
}

Write-Output ''
Write-Output '## Skills'
foreach ($s in $sources) {
    $dir = Join-Path $s.Base 'skills'
    if (-not (Test-Path $dir)) { continue }
    Get-ChildItem -LiteralPath $dir -Directory | ForEach-Object {
        $skillFile = Join-Path $_.FullName 'SKILL.md'
        if (-not (Test-Path $skillFile)) { return }
        $m = Get-Frontmatter $skillFile
        $name = if ($m['name']) { $m['name'] } else { $_.Name }
        Write-Output ("- [{0}] {1} :: {2}  ({3})" -f $s.Scope, $name, $m['description'], $skillFile)
    }
}
