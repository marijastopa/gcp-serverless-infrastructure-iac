# Deployment Guide

## Dev Deployment

Automatic on merge to main:
```bash
git checkout -b feature/my-change
# make changes
git push
# Create PR, merge
# → Dev deploys automatically
```

## Production Deployment

Tag-based with manual approval:
```bash
# 1. Ensure dev is stable and tested
# 2. Create release tag
git tag -a v1.0.0 -m "Release v1.0.0: feature description"
git push origin v1.0.0

# 3. GitHub Actions triggers prod workflow
# 4. Review plan output in Actions
# 5. Click "Review deployments" → "Approve"
# 6. Prod applies
```

## Rollback Procedure

### Bad tag (before approval):
```bash
git tag -d v1.0.0
git push origin :refs/tags/v1.0.0
# Fix issue, create new tag
```

### Failed deployment:
```bash
./scripts/rollback.sh prod v0.9.0
```

### Deployed but broken:
```bash
# Fast rollback via new tag pointing to old commit
git tag -a v1.0.1 -m "Rollback to v0.9.0" <old-commit-sha>
git push origin v1.0.1
# Approve in GitHub Actions
```

## Semantic Versioning

- `v1.0.0` → Major (breaking changes)
- `v1.1.0` → Minor (new features)
- `v1.0.1` → Patch (bug fixes)