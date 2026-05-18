# GuideTree session-start hook (Windows PowerShell) - health check + context injection
$ErrorActionPreference = "Stop"

$pluginRoot = $env:CLAUDE_PLUGIN_ROOT
$skillCount = (Get-ChildItem "$pluginRoot\skills" -Directory 2>$null).Count

Write-Host "[guidetree] v1.0 health check"
Write-Host "  Skills: $skillCount"

$checks = @("references\paths.yml", "catalog\skills.yml")
foreach ($f in $checks) {
    if (Test-Path "$pluginRoot\$f") {
        Write-Host "  $f : OK"
    } else {
        Write-Host "  $f : MISSING"
    }
}

Write-Host "[guidetree] Ready."

# Build a compact context summary
$summary = "<EXTREMELY_IMPORTANT>`n"
$summary += "You have the GuideTree plugin ($skillCount skills).`n`n"
$summary += "GuideTree is a hierarchical project planning and execution pipeline:`n"
$summary += "project → phase → stage → step, with validation gates at every level.`n`n"
$summary += "Skills available:`n"
$summary += "- guidetree:orchestrate_project -- Select the next correct skill based on project state. Use /orchestrate_project or say `"continue project`".`n"
$summary += "- guidetree:create_project_context -- Normalize raw project description into structured context.`n"
$summary += "- guidetree:generate_phase_skeleton -- Decompose project into lifecycle phases.`n"
$summary += "- guidetree:validate_phase_skeleton -- Validate phase coverage, DAG, and criteria.`n"
$summary += "- guidetree:expand_phase_to_stage_dag -- Decompose one phase into stage DAG.`n"
$summary += "- guidetree:validate_stage_dag -- Validate stage schema and phase coverage.`n"
$summary += "- guidetree:expand_stage_to_steps -- Decompose one stage into executable steps.`n"
$summary += "- guidetree:validate_steps -- Validate step executability and stage coverage.`n"
$summary += "- guidetree:execute_step -- Execute one step with evidence collection.`n"
$summary += "- guidetree:validate_stage_result -- Validate completed stage against criteria.`n`n"
$summary += "When validation fails, repair is handled by re-invoking the generate skill with validation feedback. No separate repair skills.`n`n"
$summary += "Pipeline order: create_project_context → generate_phase_skeleton → validate_phase_skeleton → expand_phase_to_stage_dag → validate_stage_dag → expand_stage_to_steps → validate_steps → execute_step → validate_stage_result → (repeat or complete).`n"
$summary += "</EXTREMELY_IMPORTANT>"

$output = @{
    hookSpecificOutput = @{
        hookEventName = "SessionStart"
        additionalContext = $summary
    }
} | ConvertTo-Json -Depth 3

Write-Output $output

exit 0
