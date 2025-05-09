#!/usr/bin/env bash
set -euo pipefail

# ─── CONFIGURATION ─────────────────────────────────────────────────────────────
# Your Vercel team or username
SCOPE="diego-pamios-projects"

# Map each local folder to its Vercel project name:
dirs=("apps/api" "apps/app" "apps/web")
projects=("conversational-cv-api" "conversational-cv-app" "conversational-cv-web")
# ────────────────────────────────────────────────────────────────────────────────

# Sanity check: arrays must be same length
if [ "${#dirs[@]}" -ne "${#projects[@]}" ]; then
  echo "❌ Error: 'dirs' and 'projects' arrays have different lengths" >&2
  exit 1
fi

# Iterate
for i in "${!dirs[@]}"; do
  DIR="${dirs[i]}"
  PROJECT="${projects[i]}"
  echo
  echo "🔗 Linking $DIR → Vercel project '$PROJECT' (scope: $SCOPE)..."
  pushd "$DIR" >/dev/null

  # Link this folder (answer 'y' when prompted)
  vercel link --project "$PROJECT" --scope "$SCOPE"

  echo "📝 Syncing .env.local → preview & production for '$PROJECT'..."

  # Pull existing keys
  existing_preview=$(vercel env ls preview | tail -n +2 | awk '{print $1}')
  existing_prod=$(vercel env ls production | tail -n +2 | awk '{print $1}')

  # Loop through each line of .env.local
  while IFS='=' read -r KEY VAL; do
    # skip blank lines or comments
    [[ -z "$KEY" || "${KEY:0:1}" == "#" ]] && continue

    echo " • $KEY"
    # PREVIEW
    if printf '%s\n' "$existing_preview" | grep -qx "$KEY"; then
      echo "   – preview exists, skipping"
    else
      printf '%s\n' "$VAL" | vercel env add "$KEY" preview
    fi
    # PRODUCTION
    if printf '%s\n' "$existing_prod" | grep -qx "$KEY"; then
      echo "   – production exists, skipping"
    else
      printf '%s\n' "$VAL" | vercel env add "$KEY" production
    fi

  done < .env.local

  popd >/dev/null
done

echo
echo "✅ All done! You can verify with 'vercel env ls preview' / 'vercel env ls production' inside each folder."

