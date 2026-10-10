#!/bin/bash

URL="https://www.stickman-records.com/shop/elder-through-zero/"
SOUNDS=(
  /System/Library/Sounds/Glass.aiff
  /System/Library/Sounds/Hero.aiff
  /System/Library/Sounds/Ping.aiff
  /System/Library/Sounds/Sosumi.aiff
  /System/Library/Sounds/Funk.aiff
)

alarm() {
  while true; do
    SOUND=${SOUNDS[$((RANDOM % ${#SOUNDS[@]}))]}
    afplay "$SOUND" &
    sleep 1
  done
}

while true; do
  STATUS=$(curl -sL -o /dev/null -w "%{http_code}" "$URL")

  if [ "$STATUS" -eq 200 ]; then
    echo "$(date): Page is LIVE! (HTTP $STATUS)"

    alarm &
    ALARM_PID=$!

    RESULT=$(osascript -e "display dialog \"The Elder - Through Zero page is now live!\n\n$URL\" with title \"🚨 Page is Live!\" buttons {\"Open Page\", \"Dismiss\"} default button \"Open Page\"")

    kill $ALARM_PID 2>/dev/null
    killall afplay 2>/dev/null

    if echo "$RESULT" | grep -q "Open Page"; then
      open "$URL"
    fi
    exit 0
  else
    echo "$(date): Not live yet (HTTP $STATUS). Checking again in 60s..."
  fi

  sleep 60
done
