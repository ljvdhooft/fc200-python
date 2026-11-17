#!/bin/sh
# Tags HEAD of dev as the next release (vMAJOR.MINOR.PATCH) and pushes the tag.
# Shows the commits since the last release and asks which part to bump.
# The tag message lists those commits. Run through `make release`.
set -e

[ "$(git branch --show-current)" = dev ] || { echo "run this on dev"; exit 1; }
[ -z "$(git status --porcelain)" ] || { echo "uncommitted changes; commit or stash them first"; exit 1; }

last=$(git tag --list 'v[0-9]*.[0-9]*.[0-9]*' --sort=-v:refname | head -n1)
if [ -n "$last" ]; then
	[ "$(git rev-list -n1 "$last")" != "$(git rev-parse HEAD)" ] || { echo "HEAD is already released as $last"; exit 1; }
	range=$last..HEAD
else
	range=HEAD
fi

IFS=. read -r major minor patch <<EOF
${last#v}
EOF
major=${major:-0} minor=${minor:-0} patch=${patch:-0}

changes=$(git log --oneline --no-merges "$range")
echo "Changes since ${last:-the start}:"
echo "$changes" | sed 's/^/  /'
echo
echo "  1) patch  v$major.$minor.$((patch + 1))"
echo "  2) minor  v$major.$((minor + 1)).0"
echo "  3) major  v$((major + 1)).0.0"
printf "Version (1-3 or x.y.z) [1]: "
read -r answer
case ${answer:-1} in
	1) tag=v$major.$minor.$((patch + 1)) ;;
	2) tag=v$major.$((minor + 1)).0 ;;
	3) tag=v$((major + 1)).0.0 ;;
	*) tag=v${answer#v} ;;
esac
echo "$tag" | grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+$' || { echo "not a version: $answer"; exit 1; }
! git rev-parse -q --verify "refs/tags/$tag" >/dev/null || { echo "$tag already exists"; exit 1; }

printf 'Release %s\n\n%s\n' "$tag" "$changes" | git tag -a "$tag" -F -
git push -q origin "$tag"
echo "released $tag; deploy it with 'make deploy' in fc200-python-main"
