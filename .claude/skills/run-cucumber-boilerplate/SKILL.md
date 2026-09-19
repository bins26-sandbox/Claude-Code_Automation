---
name: run-cucumber-boilerplate
description: Build, run, and drive the cucumber-boilerplate WebdriverIO+Cucumber test suite (SauceDemo login/sort scenarios plus the original boilerplate demo-app scenarios). Use when asked to run this project's tests, run a specific .feature file, add a new Cucumber scenario, or verify a Gherkin step against the real site.
---

This is a [webdriverio/cucumber-boilerplate](https://github.com/webdriverio/cucumber-boilerplate)
project (TypeScript, WebdriverIO 9, Cucumber). There is no server/GUI to
launch — the "app" is the `wdio` CLI running headless Chrome against
either the real internet (SauceDemo scenarios) or a bundled static
demo-app. Drive it via
`.claude/skills/run-cucumber-boilerplate/smoke.sh`, which wraps the
project's own headless config (`wdio.BUILD.conf.ts`) so no display/Xvfb
setup is needed.

All paths below are relative to the repo root.

## Prerequisites

None beyond Node + npm. Verified in this container with Node v24.20.0
and no `DISPLAY` set (`.nvmrc` says v18.20.2, but v24 works fine).
WebdriverIO downloads its own "Chrome for Testing" browser + driver on
first run — nothing to `apt-get install`, and it runs headless with no
Xvfb even for the non-headless-looking `wdio.conf.ts` capabilities.

## Setup

```bash
npm install
```

## Run (agent path)

```bash
.claude/skills/run-cucumber-boilerplate/smoke.sh
```

Runs the two SauceDemo scenarios (login + sort) headless, hitting the
real `https://www.saucedemo.com/`. Verified output:

```
Successful login with standard_user
   ✓ Given I open the url "https://www.saucedemo.com/"
   ✓ And I clear the inputfield "#user-name"
   ...
   ✓ Then I expect that the url is "https://www.saucedemo.com/inventory.html"
9 passing (1.1s)
...
Sort products by Name (A to Z) and verify the first product
   ✓ ...
   ✓ Then I expect that element ".inventory_item_name" matches the text "Sauce Labs Backpack"
9 passing (1s)

Spec Files:	 2 passed, 2 total (100% completed)
```

Other invocations:

```bash
# one specific feature file
.claude/skills/run-cucumber-boilerplate/smoke.sh src/features/sauceDemoLogin.feature

# the entire src/features/**/*.feature suite, including the original
# boilerplate demo-app scenarios (spins up a local static server on :8080)
.claude/skills/run-cucumber-boilerplate/smoke.sh --all
```

Exit code is `wdio`'s own (0 = all scenarios passed).

## Run (human path)

```bash
npx wdio run wdio.conf.ts --spec src/features/sauceDemoLogin.feature
```

Uses the non-headless capabilities in `wdio.conf.ts` — opens a real
Chrome window if a display is available (falls back fine with none, as
confirmed above). `npm test` runs lint + unit tests + the full feature
suite in one shot (see Test below).

## Test

```bash
npm run test:lint    # eslint, exit 0, no output on this repo
npm run test:unit    # jest: 43 suites / 104 tests, ~1s
npm run test:features  # == smoke.sh --all: full src/features suite
```

`npm test` chains all three via `run-s` and **exits 1** — not from
this work, but because `test:features` includes 4 pre-existing broken
scenarios in the upstream boilerplate's own demo/external-site
features (see Gotchas). `sauceDemoLogin.feature` and
`sauceDemoSort.feature` pass every time; run `smoke.sh` (no `--all`)
for a clean, fast, relevant signal.

---

## Gotchas

- **Re-navigating to the same URL in one browser session drops typed
  input.** If two scenarios in the *same* `.feature` file both do
  `Given I open the url "https://www.saucedemo.com/"` and log in, the
  second login's `#user-name`/`#password` fields silently end up empty
  (focus works, keystrokes don't register) roughly half the time —
  looks like a same-URL navigation getting coalesced/bfcache-restored
  instead of a true reload, which leaves the SPA's React state stale.
  WebdriverIO's local runner gives each **spec file** its own fresh
  browser session by default, so the fix is one Scenario needing a
  fresh login per `.feature` file, not per `Scenario:` block inside a
  shared one. That's why `sauceDemoLogin.feature` and
  `sauceDemoSort.feature` are separate files instead of two scenarios
  in one file — confirmed stable across repeated runs after the split,
  where it flaked intermittently before.
- **`.inventory_list is displayed` can race the SPA's render right
  after clicking login.** Use `becomes displayed` (polls) instead of
  `is displayed` (instant check) for anything asserted immediately
  after a navigation/click.
- **4 pre-existing failures in `--all` are not from this work**:
  `elementPosition.feature`, `githubSearch.feature`, `drag.feature`,
  `sampleSnippets.feature` (the last via a `structure.feature`-style
  `http://` vs `https://` redirect on `guinea-pig.webdriver.io`) —
  these hit real external sites the upstream boilerplate points at and
  were already broken/flaky before the SauceDemo scenarios were added.
  `sauceDemoLogin.feature` and `sauceDemoSort.feature` pass every time.

## Troubleshooting

- **`wdio` hangs or a fresh run behaves oddly right after a killed/interrupted
  previous run**: a stray `chromedriver` process is holding a port.
  `smoke.sh` already does this before launching, but if driving `wdio`
  directly: `pkill -f chromedriver; pkill -f "Google Chrome for Testing"`.
