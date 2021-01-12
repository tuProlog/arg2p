# Changelog

## [Unreleased]
### Added
- Aspic+ missing features (premises, axioms, undercuts, (contrary) undermines)
- Aspic+ preference handling principles (elitist/democrat last/weakest link)
- Automatic transposition closure
- Optional restricted rebut (through `unrestrictedRebut` flag)
- Dung's Normal Attack Relation
- Dung's preference-based argumentation (pgraph)
- Complete labelling semantic
- Pure prolog premises (prolog{})
- Skeptical and credulous acceptance
### Changed
- Improved modularisation through flags selection
### Removed
- Argumentation graph visualisation

## [0.3.3] - 2020-10-26
### Fixed
- answerQuery/4 fix

## [0.3.2] - 2020-10-13
### Fixed
- Sort bug
- Strong negation in answerQuery/4
- Theory admissibility check


## [0.3.1] - 2020-08-28
### Changed
- Argument list in graph visualisation tab
### Fixed
- BP labelling algorithm adapted to its latest definition (statements a.ii and b.ii.1)

## [0.3.0] - 2020-08-25
### Added
- Argumentation graph visualisation on buildLabelSets/0 and buildLabelSets/2.
### Changed
- Rename printLabelSets/0 to buildLabelSets/0.
- Rename the "partialHBP" flag to "disableBPcompletion".
- Rename enablePartialHBP/0 and disablePartialHBP/0 to enableBPCompletion/0 and disableBPCompletion/0 respectively.
### Fixed
- Backtracking support in modular calls.

## [0.2.0] - 2020-07-06
### Added
- Modular reasoning.

## [0.1.0] - 2020-06-17
### Added
- Deb/OSX/Windows support.

