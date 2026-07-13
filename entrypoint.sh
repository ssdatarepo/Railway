#!/bin/sh
set -e

# Recreate the credential files from Railway env vars at container start.
# These files are gitignored/dockerignored, so they only exist here at runtime.
if [ -n "$GOOGLE_SERVICE_ACCOUNT_JSON" ]; then
  echo "$GOOGLE_SERVICE_ACCOUNT_JSON" > ss.json
else
  echo "WARNING: GOOGLE_SERVICE_ACCOUNT_JSON is not set" >&2
fi

if [ -n "$TRACXN_SESSION_JSON" ]; then
  echo "$TRACXN_SESSION_JSON" > tracxn_session.json
else
  echo "WARNING: TRACXN_SESSION_JSON is not set" >&2
fi

exec "$@"
