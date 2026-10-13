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

# Плавный расчет задержки:
# d=2: задержка 0.130s
# d>=6: задержка 0.055s
STEP_DELAY=$(awk -v d="$DIFF" 'BEGIN {
    # Базовое затухание по гиперболе
    delay = 0.130 - ((d - 2) * 0.015);
    if (delay < 0.055) delay = 0.055;
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
