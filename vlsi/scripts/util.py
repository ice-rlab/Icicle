from typing import Dict
from typing import List


COLORS: List[str] = ['#9bbb59', "#c0504d", '#7030a0', '#ffc000',]


COL_RET: str = COLORS[0]
COL_BAD: str = COLORS[1]
COL_FE: str = COLORS[2]
COL_BE: str = COLORS[3]

COLORS_BACKEND: List[str] = ['#ff99cc', '#c0504d', '#4f81bd']
COL1: str = COLORS_BACKEND[0]
COL2: str = COLORS_BACKEND[1]
COL3: str = COLORS_BACKEND[2]

COUNTERS: List[str] = [
    "Cycle",
    "Int Ret",
    "Slots Issued",
    "Fetch bubbles",
    "Recovering",
    "Fp Stall",
    "Div Stall",
    "Replay",
    "IBuf Valid",
    "Br misses",
    "DCache blocked",
    "Hazard",
    "Flush",
    "Br Dir Miss",
    "ICache miss",
    "DCache miss",
    "DCache WB",
    "ITLB Miss",
    "DTLB",
    "L2 TLB MISS"
]

EXPERIMENTS: List[str] = [
    "backtrack",
    "dft",
    "dhrystone",
    "fc_forward",
    "graph",
    "insertionsort",
    "matrix_mult_rec",
    "mergesort",
    "mm-naive",
    "mm-loop-reorder",
    "multiply",
    "nvdla",
    "omegalul",
    "outer_product",
    "pingd",
    "pmp",
    "priority_queue",
    "pwm",
    "qsort",
    "quicksort",
    "rsort",
    "sort_search",
    "spiflashread",
    "spiflashwrite",
    "spmv",
    "streaming-fir",
    "streaming-passthrough"
    "symmetric",
    "towers",
    "vvadd",
    "mm",
    "median",
    "bfs",
    "coremark_O2_no_sched2",
    "coremark_O2_no_sched12",
    "coremark_O2_no_sched1",
    "coremark_O2_no_interblock",
    "coremark_O2_sched",
    "coremark_O2",
    "coremark"
]


def get_filename_without_extension(file_path: str) -> str:
    filename = os.path.basename(file_path)
    name_without_extension = filename.split('.')[0]
    return name_without_extension


def get_benchmark_name(file_name: str) -> str:
    for ex in EXPERIMENTS:
        if ex in file_name:
            return ex
    return file_name


def get_counter(counter_dict: Dict[str, str], name: str) -> int:
    return int(counter_dict[name])


def read_counters_file(file_path: str) -> Dict[str, str]:
    counters_dict = {}
    with open(file_path, 'r') as file:
        try:
            for line in file:
                line = line.strip()
                if ': ' in line:
                    parts = line.split(': ')
                    if len(parts) == 2:
                        name, counter = parts
                        try:
                            number = int(counter)
                            counters_dict[name] = counter
                        except ValueError:
                            continue
        except:
            pass
    return counters_dict


def format_number(value: float, scale_factor: float = 1.0, unit: str = "") -> str:
    value = float(value) * scale_factor
    unit = unit if unit else ""
    if value >= 1e6:
        return f'{value / 1e6:.1f}M{unit}'
    elif value >= 1e3:
        return f'{value / 1e3:.1f}k{unit}'
    else:
        return f'{value:.3f}{unit}'


def format_number_int(value: int) -> str:
    if value >= 1e6:
        return f'{value / 1e6:.0f}M'
    elif value >= 1e3:
        return f'{value / 1e3:.0f}k'
    else:
        return f'{value:.0f}'
