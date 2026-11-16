-- Starts the hub without Live (normally the Remote Script starts it) and opens
-- the web app. Compiled into ~/Applications by install.sh. The hub stops again
-- when the Remote Script unloads, or with: launchctl kill SIGTERM gui/$(id -u)/nl.fc200.hub
do shell script "launchctl kickstart gui/$(id -u)/nl.fc200.hub"
delay 1
open location "http://localhost:200"
