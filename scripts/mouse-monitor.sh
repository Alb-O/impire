#!/usr/bin/env bash
# Mouse stutter monitor - run while using mouse, Ctrl+C after lag to see analysis

set -uo pipefail

LOGDIR="/tmp/mouse-monitor-$$"
mkdir -p "$LOGDIR"

EVLOG="$LOGDIR/events.log"
DMESGLOG="$LOGDIR/dmesg.log"

# Check for root
if [[ $EUID -ne 0 ]]; then
    echo "Run with: sudo $0"
    exit 1
fi

echo "Monitoring mouse via libinput"
echo "Logs: $LOGDIR"
echo "Move mouse continuously. Press Ctrl+C right after you notice stutter."
echo "---"

cleanup() {
    echo -e "\n--- Stopping capture ---"
    kill "${LIBINPUT_PID:-}" "${DMESG_PID:-}" "${TAIL_PID:-}" 2>/dev/null || true
    wait 2>/dev/null || true
    
    echo -e "\n=== ANALYSIS ==="
    
    # Find gaps > 30ms in the event stream
    echo -e "\n[Event gaps > 30ms]"
    awk '
    /POINTER_MOTION/ {
        # Timestamp is first field (epoch.ms)
        ts = $1 + 0
        if (last > 0) {
            delta = ts - last
            if (delta > 0.030 && delta < 10) {
                gap_count++
                printf "  gap: %.0fms\n", delta*1000
            }
        }
        last = ts
    }
    END {
        if (gap_count > 0) printf "\nTotal suspicious gaps: %d\n", gap_count
        else print "  No significant gaps detected"
    }
    ' "$EVLOG"
    
    # Show any USB/HID kernel messages
    echo -e "\n[Kernel messages (USB/HID)]"
    if [[ -s "$DMESGLOG" ]]; then
        cat "$DMESGLOG"
    else
        echo "  None"
    fi
    
    echo -e "\n[Last 10 motion events]"
    grep POINTER_MOTION "$EVLOG" 2>/dev/null | tail -10 | cut -c1-100
    
    echo -e "\nRaw logs: $LOGDIR"
}

trap cleanup EXIT

# Timestamp each line with millisecond precision using perl
libinput debug-events 2>&1 | perl -MTime::HiRes=time -pe 'BEGIN{$|=1} $_ = sprintf("%.3f %s", time(), $_)' > "$EVLOG" &
LIBINPUT_PID=$!

# Start dmesg watch for USB/HID errors
dmesg -wT 2>/dev/null | grep --line-buffered -iE "(usb|hid|logi)" > "$DMESGLOG" &
DMESG_PID=$!

echo "Watching for gaps (>30ms shown in red)..."
sleep 1

# Live gap detection
tail -f "$EVLOG" 2>/dev/null | awk '
/POINTER_MOTION/ {
    ts = $1 + 0
    if (last > 0) {
        delta = ts - last
        if (delta > 0.030 && delta < 10) {
            printf "\033[31mGAP: %.0fms\033[0m\n", delta*1000
        }
    }
    last = ts
}
' &
TAIL_PID=$!

wait $LIBINPUT_PID
