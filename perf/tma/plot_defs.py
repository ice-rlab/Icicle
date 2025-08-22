from typing import Dict
from typing import List

PALETTES = {
    "default":      ['#9bbb59', '#c0504d', '#7030a0', '#ffc000'],
    "backend":      ['#ff99cc', '#c0504d', '#4f81bd'],
    "frontend":     ['#f79646', '#c0504d', '#4f81bd'],
    "badspec":      [
        '#955196',  # existing 0
        '#003f5c',  # existing 1
        '#4f81bd',  # existing 2
        '#c0504d',  # new for Flush
        '#9bbb59',  # new for RecoveryBubbles
    ],
}

COLORS: List[str] = PALETTES["default"]

# unpack as named constants (optional)
COL_RET,      COL_BAD,      COL_FE,      COL_BE      = PALETTES["default"]
COL_BACK1,    COL_BACK2,    COL_BACK3               = PALETTES["backend"]
COL_FRONT1,   COL_FRONT2,   COL_FRONT3              = PALETTES["frontend"]
COL_BAD1,     COL_BAD2,     COL_BAD3,  COL_FLUSH, COL_RECOV = PALETTES["badspec"]

# build your map of event→color
COLORS_MAP = {
    "Retiring":              COL_RET,
    "BadSpeculation":        COL_BAD,
    "Frontend":              COL_FE,
    "Backend":               COL_BE,
    "MemBound":              COL_BACK1,
    "CoreBound":             COL_BACK3,
    "FetchLatency":          COL_FRONT1,
    "PCResolution":          COL_FRONT2,
    "MachineClears":         COL_BAD1,
    "BranchMispredictions":  COL_BAD2,
    "Flush":                 COL_FLUSH,
    "RecoveryBubbles":       COL_RECOV,
}

def format_number(value: float) -> str:
    if value >= 1e6:
        return f'{value / 1e6:.1f}M'
    elif value >= 1e3:
        return f'{value / 1e3:.1f}k'
    else:
        return f'{value:.3f}'


def format_number_int(value: int) -> str:
    if value >= 1e6:
        return f'{value / 1e6:.0f}M'
    elif value >= 1e3:
        return f'{value / 1e3:.0f}k'
    else:
        return f'{value:.0f}'
    
    




