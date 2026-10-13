#!/usr/bin/env bash

TARGET="$1"
[[ -z "$TARGET" ]] && exit 0

CURRENT=$(hyprctl activeworkspace -j | grep -m1 '"id":' | tr -dc '0-9')
[[ -z "$CURRENT" ]] && exit 0
[[ "$CURRENT" -eq "$TARGET" ]] && exit 0

DIFF=$(( TARGET > CURRENT ? TARGET - CURRENT : CURRENT - TARGET ))

if (( DIFF == 1 )); then
    hyprctl dispatch "hl.dsp.focus({ workspace = $TARGET })" >/dev/null
    exit 0
fi

STEP_DELAY=$(awk -v d="$DIFF" 'BEGIN {
    delay = 0.16 / (d - 1);
    if (delay > 0.080) delay = 0.080;
    if (delay < 0.018) delay = 0.018;
    printf "%.3f", delay;
}')

if (( TARGET > CURRENT )); then
    for (( w=CURRENT+1; w<=TARGET; w++ )); do
        hyprctl dispatch "hl.dsp.focus({ workspace = $w })" >/dev/null
        (( w != TARGET )) && sleep "$STEP_DELAY"
    done
else
    for (( w=CURRENT-1; w>=TARGET; w-- )); do
        hyprctl dispatch "hl.dsp.focus({ workspace = $w })" >/dev/null
        (( w != TARGET )) && sleep "$STEP_DELAY"
    done
fi
