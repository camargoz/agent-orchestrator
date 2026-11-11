# Instala a skill "orchestrator" no Claude Code.
#
#   .\install.ps1                      -> instala globalmente em ~\.claude\skills\ (todos os projetos)
#   .\install.ps1 -ProjectRoot C:\x\y  -> instala só nesse projeto, em C:\x\y\.claude\skills\
#
# Rode de novo para atualizar. Depois de instalar, reinicie o Claude Code.

param(
    [string]$ProjectRoot = ''
)

$repoRoot = $PSScriptRoot
$source = Join-Path $repoRoot 'skills\orchestrator'

if ($ProjectRoot -ne '') {
    $target = Join-Path $ProjectRoot '.claude\skills\orchestrator'
} else {
    $target = Join-Path $HOME '.claude\skills\orchestrator'
}

New-Item -ItemType Directory -Force -Path (Split-Path $target -Parent) | Out-Null
if (Test-Path $target) { Remove-Item -LiteralPath $target -Recurse -Force }
Copy-Item -LiteralPath $source -Destination $target -Recurse -Force

Write-Output "Skill 'orchestrator' instalada em: $target"
Write-Output 'Reinicie o Claude Code para carregar a skill.'
