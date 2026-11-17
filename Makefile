# Releases are annotated tags vMAJOR.MINOR.PATCH whose message lists the commits
# since the previous release.
#   make release             on dev: asks for the version, tags HEAD and pushes the tag
#   make deploy [V=<tag>]    in the production worktree (fc200-python-main, detached):
#                            checks out the tag (default: the newest), updates the
#                            hub's Python packages, builds the web app and reinstalls
#                            the launchd agent (which restarts the hub) and FC200 Hub.app.
# Rolling back is deploying an older tag. Live still needs a restart to load new
# Remote Script code (Suite can't reload).

.PHONY: release deploy dev mock test

# Development: the hub on :20031 plus Vite on :5173 (hot reload; it proxies /ws to
# the hub). Open http://<this Mac's IP>:5173 on the phone. Ctrl-C stops both.
# --no-mdns: fc200.local belongs to the production hub.
#   make dev    hub talks to the Remote Script in Live (:20030)
#   make mock   hub plays scripted fake state, no Live needed
dev mock:
	@trap 'kill 0' EXIT; \
	(cd apps/hub && .venv/bin/python -m fc200_hub --no-mdns $(if $(filter mock,$@),--mock)) & \
	cd apps/web && npm run dev

# Every check that runs without Live
test:
	python3.11 -m unittest discover -s tests
	mypy
	cd apps/hub && .venv/bin/python -m pytest -q
	cd apps/web && npm test --silent && npm run check

release:
	@tools/release.sh

deploy:
	@test -z "$$(git branch --show-current)" || { echo "run this in the production worktree (fc200-python-main, detached at a release)"; exit 1; }
	@test -z "$$(git status --porcelain)" || { echo "uncommitted changes; commit or stash them first"; exit 1; }
	@tag="$(V)"; test -n "$$tag" || tag=$$(git tag --list 'v*' --sort=-v:refname | head -n1); \
	test -n "$$tag" || { echo "no release tags yet; run 'make release' on dev"; exit 1; }; \
	echo "deploying $$tag"; git checkout -q --detach "$$tag"
	test -d apps/hub/.venv || python3.14 -m venv apps/hub/.venv
	apps/hub/.venv/bin/pip install -q -r apps/hub/requirements.txt
	cd apps/web && npm ci --silent && npm run build
	apps/hub/launchd/install.sh
