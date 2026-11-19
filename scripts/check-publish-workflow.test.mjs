import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { audit, WORKFLOW } from './check-publish-workflow.mjs';

test('the real publish job goes through a PR, never a direct push to main', () => {
  assert.deepEqual(audit(readFileSync(WORKFLOW, 'utf8')), []);
});

test('the guard catches a bare git push and a PR that is never merged', () => {
  const old = `  publish:\n    steps:\n      - run: |\n          git push\n`;
  const problems = audit(old);
  assert.ok(problems.includes('publish pushes to the tracking branch'));
  assert.ok(problems.includes('publish does not open a PR'));
  assert.ok(problems.includes('publish does not merge the PR'));
});

test('pushing a named release branch is allowed', () => {
  const ok = `  publish:\n    steps:\n      - run: |\n          git push -u origin "bot/flisk-$VERSION"\n          gh pr create --base main --head "bot/flisk-$VERSION"\n          gh pr merge --squash "bot/flisk-$VERSION"\n`;
  assert.deepEqual(audit(ok), []);
});
