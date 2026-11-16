# Production deploy. Run it in the production worktree (fc200-python-main, on main):
#   make deploy
# It fast-forwards main to dev, updates the hub's Python packages, builds the web
# app and reinstalls the launchd agent (which restarts the hub) and FC200 Hub.app.
# Live still needs a restart to load new Remote Script code (Suite can't reload).

.PHONY: deploy

deploy:
	@test "$$(git branch --show-current)" = main || { echo "run this on main (fc200-python-main)"; exit 1; }
	@test -z "$$(git status --porcelain)" || { echo "uncommitted changes; commit or stash them first"; exit 1; }
	git merge --ff-only dev
	test -d apps/hub/.venv || python3.14 -m venv apps/hub/.venv
	apps/hub/.venv/bin/pip install -q -r apps/hub/requirements.txt
	cd apps/web && npm ci --silent && npm run build
	apps/hub/launchd/install.sh
