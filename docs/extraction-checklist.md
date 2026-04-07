# Extraction Checklist

Use this checklist when moving specClawd into its own repository.

## Before Extraction

- confirm `specClawd/scripts/check.sh` passes
- confirm `specClawd/scripts/release-preflight.sh` passes
- confirm README and release docs are ready for public readers

## Extraction

1. create a new empty repository directory
2. run:

```bash
specClawd/scripts/extract-standalone.sh --target /path/to/new/specClawd
```

3. initialize git in the target directory
4. review copied files

## After Extraction

- run `scripts/check.sh` in the new repository root
- run `scripts/release-preflight.sh`
- verify `install/init.sh` still works from the new repository root
- verify example files still read correctly
- replace root `README.md` with `docs/standalone-readme.md`
- update repository metadata on GitHub

## First Commit Recommendation

- commit the extracted repository as-is
- avoid mixing extraction and new feature work in the same initial commit

## First Release Recommendation

- tag `0.1.0-alpha.1`
- use `docs/alpha-release.md` as the basis for release notes
