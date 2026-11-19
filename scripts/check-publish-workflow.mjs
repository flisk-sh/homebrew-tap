// The release updater must not push straight to `main`: the ruleset requires the GEL check, which a direct push
// cannot carry. This guard keeps the publish job on the PR path so the check runs before the formula lands.
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { pathToFileURL } from 'node:url';

export const WORKFLOW = fileURLToPath(new URL('../.github/workflows/update.yml', import.meta.url));

export function audit(input) {
  const text = input.replace(/\r\n/g, '\n');
  const problems = [];
  const publish = text.split(/\n(?= {2}[\w-]+:[ \t]*$)/m).find((job) => job.startsWith('  publish:')) || '';
  if (!publish) problems.push('no publish job');
  for (const line of publish.split('\n')) {
    if (/^\s*git push\s*(?:origin\s+)?(?:main)?\s*$/.test(line)) problems.push('publish pushes to the tracking branch');
  }
  if (!/gh pr create/.test(publish)) problems.push('publish does not open a PR');
  if (!/gh pr (?:merge|edit|--auto)/.test(publish) && !/gh pr merge/.test(publish)) problems.push('publish does not merge the PR');
  return problems;
}

export function main() {
  const problems = audit(readFileSync(WORKFLOW, 'utf8'));
  for (const problem of problems) console.error(`workflow: ${problem}`);
  console.log(`publish workflow: ${problems.length ? `${problems.length} problem(s)` : 'ok'}`);
  return problems.length;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  process.exitCode = main() ? 1 : 0;
}
