import datetime
import os

from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    Formatter,
)

CYAN = 0x@cyan@
BLUE = 0x@blue@
ORANGE = 0x@orange@
BASE1 = 0x@base1@
BASE0 = 0x@base0@


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    draw_attributed_string(Formatter.reset, screen)

    tab_text = f" {index}: {tab.title} "
    screen.cursor.fg = as_rgb(CYAN if tab.is_active else BASE1)
    screen.draw(tab_text)

    if is_last:
        draw_right_status(screen)

    return screen.cursor.x


def get_battery_status() -> str:
    try:
        for bat in os.listdir("/sys/class/power_supply"):
            if bat.startswith("BAT"):
                with open(f"/sys/class/power_supply/{bat}/capacity", "r") as f:
                    cap = f.read().strip()
                with open(f"/sys/class/power_supply/{bat}/status", "r") as f:
                    status = f.read().strip()
                prefix = "[+]" if status == "Charging" else "[-]"
                return f"{prefix} {cap}%"
    except Exception:
        pass
    return ""


def draw_right_status(screen: Screen) -> None:
    draw_attributed_string(Formatter.reset, screen)

    battery = get_battery_status()
    now = datetime.datetime.now()
    
    date_str = now.strftime("%a %d %b")
    time_str = now.strftime("%I:%M %p").lower()

    if battery:
        status = f"{battery} • {date_str} • {time_str}"
    else:
        status = f"{date_str} • {time_str}"

    padding = screen.columns - screen.cursor.x - len(status) - 1
    if padding > 0:
        screen.draw(" " * padding)

    screen.cursor.fg = as_rgb(ORANGE)
    screen.draw(status + " ")
