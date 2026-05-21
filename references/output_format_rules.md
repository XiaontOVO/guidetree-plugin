# Output Format Rules (shared)

These rules are referenced by all GuideTree skills. Keep this file in sync with all skills that produce output.

## Standard Output Format

All GuideTree skills must return:

1. **Valid JSON only.** No markdown, no comments, no explanations outside the JSON object.
2. The output must conform to the skill's `output_schema`.
3. No extra fields beyond what the schema defines.

## Common Violations

- Wrapping JSON in markdown code fences
- Including explanatory text before or after the JSON
- Adding comments inside the JSON
- Omitting required fields from output_schema
- Including fields not defined in output_schema
