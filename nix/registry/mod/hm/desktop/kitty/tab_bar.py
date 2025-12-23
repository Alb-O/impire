import datetime

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


def draw_right_status(screen: Screen) -> None:
    draw_attributed_string(Formatter.reset, screen)

    now = datetime.datetime.now()
    status = f"{now.strftime('%a %d %b')}  {now.strftime('%H:%M')}"

    padding = screen.columns - screen.cursor.x - len(status) - 1
    if padding > 0:
        screen.draw(" " * padding)

    screen.cursor.fg = as_rgb(ORANGE)
    screen.draw(status + " ")
