# Changelog

Notable changes to this Lua fork of `purescript-numbers` are recorded here. The fork
tracks its own release line (Lua 5.1 FFI on the [pslua](https://github.com/purescript-lua/purescript-lua)
compiler); the upstream PureScript history is preserved below. The format
is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and
fork entries are assembled from fragments in `changelog.d/` with
[scriv](https://scriv.readthedocs.io/) on each release.

<!-- scriv-insert-here -->

<a id='changelog-v9.1.5'></a>
## v9.1.5 - 2026-07-13

### Fixed

- `fromStringImpl` matches its `Fn4` declaration: the Lua entry is a single
  4-ary function (previously it was a chain of nested single-argument
  closures, so `Data.Number.fromString` returned a function instead of a
  `Maybe Number` — Lua silently drops the surplus arguments of the n-ary
  `runFn4` call).

<a id='changelog-v9.1.4'></a>
## v9.1.4 - 2026-07-12

### Fixed

- `Data.Number.isNaN` links (the FFI key was spelled `isNan`, so pslua dropped
  the export and calls failed at runtime on a nil field) and detects NaN via
  IEEE self-inequality (`x ~= x`) instead of comparing `tostring` spellings,
  which are not canonical across NaN signs and libcs.

## v9.1.3 - 2026-06-15

### Fixed

- `Data.Number` and `Data.Number.Format` follow the JS contract: `toPrecision`,
  `fromString`, `sign`, `max`, `min`, `toExponential`, and `toString` (#92-#98).

## v9.1.2 - 2026-06-15

### Fixed

- `toFixedNative` formats with `%f`, not `%d`, so floats are no longer
  truncated.

## v9.1.1 - 2026-06-14

### Fixed

- `Data.Number.Format` FFI uses its bound argument `n`.

<!-- scriv-end-here -->

---

The sections below are inherited from the upstream PureScript project and
predate the Lua fork.

## [Unreleased]

Breaking changes:

New features:

Bugfixes:

Other improvements:

## [v9.0.1](https://github.com/purescript/purescript-numbers/releases/tag/v9.0.1) - 2023-02-13

Other improvements:
- Add LICENSE file (#26 by @mhmdanas)

## [v9.0.0](https://github.com/purescript/purescript-numbers/releases/tag/v9.0.0) - 2022-04-27

Breaking changes:
- Add support for PureScript 0.15 (#22 by @JordanMartinez)

New features:
- Ported various functions & constants from `purescript-math` (#18 by @JamieBallingall)

  Specifically...
  - `abs`, `sign`
  - `max`, `min` (which work differently than `Number`'s `Ord` instance)
  - `ceil`, `floor`, `trunc`, `remainder`/`%`, `round`
  - `log`
  - `exp`, `pow`, `sqrt`
  - `acos`, `asin`, `atan`, `atan2`, `cos`, `sin`, `tan`
  - Numeric constants: `e`, `ln2`, `ln10`, `log10e`, `log2e`, `pi`, `sqrt1_2`,
  `sqrt2`, and `tau`

Bugfixes:

Other improvements:
- Removed dependency on `purescript-math`

## [v8.0.0](https://github.com/purescript/purescript-numbers/releases/tag/v7.0.0) - 2021-02-26

Breaking changes:
- Added support for PureScript 0.14 and dropped support for all previous versions (#11)

New features:
- Ported `Number`-related code from deprecated `purescript-globals` into this repo (#12)

Other improvements:
- Replaced unicode symbols with ascii characters (#11)
- Migrated tests to use `assert` instead of `test-unit` (#10)
- Migrated CI to GitHub Actions and updated installation instructions to use Spago (#13)
- Added a changelog and pull request template (#14)

## [v7.0.0](https://github.com/purescript/purescript-numbers/releases/tag/v7.0.0) - 2019-07-07

- Updated for PureScript 0.13 (@sharkdp)

## [v6.0.0](https://github.com/purescript/purescript-numbers/releases/tag/v6.0.0) - 2018-05-27

- Updated for PureScript 0.12 (@justinwoo)

## [v5.0.0](https://github.com/purescript/purescript-numbers/releases/tag/v5.0.0) - 2017-04-30

- Added functions for formatting numbers
- Refactored

## [v4.1.0](https://github.com/purescript/purescript-numbers/releases/tag/v4.1.0) - 2017-04-16

- Added `fromString`, a safe version of `parseFloat` (@i-am-tom)
- Added `nan`, `isNaN`, `infinity` and `isFinite` from `purescript-globals`.

## [v4.0.0](https://github.com/purescript/purescript-numbers/releases/tag/v4.0.0) - 2017-04-15

- Updated for PureScript 0.11

## [v3.0.0](https://github.com/purescript/purescript-numbers/releases/tag/v3.0.0) - 2016-10-29

- Updated for PureScript 0.10

## [v2.0.0](https://github.com/purescript/purescript-numbers/releases/tag/v2.0.0) - 2016-08-26

- Updated documentation

## [v1.0.0](https://github.com/purescript/purescript-numbers/releases/tag/v1.0.0) - 2016-08-23

- Initial versioned release
