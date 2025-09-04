import matplotlib.pyplot as plt
import numpy as np
import math
import os
import argparse
from matplotlib.patches import Patch

from plot_defs import *


def create_tma_plot(out_name, benchmarks, labels, list_of_values, IPCS,
                    colors=COLORS, show_ipc=True, corewidth=1,
                    width: float = 5.5, height: float = 4.5, lh=1.08, ylim=None):
    y_raw = max([sum(x) for x in list_of_values])
    y_lim = ylim
    if ylim is None:
        y_lim = min(1.0, math.ceil(y_raw * 10) / 10.0)
    print("yllim: " + str(y_lim))
    num_bars = len(list_of_values)
    assert (num_bars == len(benchmarks)), "Numbers of bars do not match length of benchmarks"

    # Rescale IPCS to corewidth
    IPCS = [x / corewidth for x in IPCS]

    fig, ax = plt.subplots(figsize=(width, height))
    ax.grid(axis='y', linestyle='--', linewidth=0.6, alpha=0.6)
    ax.set_axisbelow(True)

    # Keep your existing colors mapping (colors depend on label name)
    colors = [COLORS_MAP[x] for x in labels]

    # Define hatches purely by order (NOT tied to colors)
    HATCHES = ["", "//", "\\\\", "xx", "oo", "..", "--", "++", "**"]

    bar_width = 0.3  # Make bars a bit skinnier

    for bar_position, values in enumerate(list_of_values):
        bottom = np.zeros(len(values))
        for i, value in enumerate(values):
            b = ax.bar(
                bar_position,
                value,
                width=bar_width,
                bottom=bottom[i],
                label=labels[i] if bar_position == 0 else "",
                color=colors[i],
                hatch=HATCHES[i % len(HATCHES)],  # <- hatch by order
                edgecolor="black",                 # improve B/W legibility
                linewidth=0.4
            )
            # Update bottoms for remaining segments
            bottom[i + 1:] += value
    num_ticks = 5
    yticks = np.linspace(0.0, y_lim, num_ticks + 1)

    yticks_right = np.linspace(0.0, 1.1 * corewidth, num_ticks + 1)
    plt.yticks(yticks)

    # Remove extra x-margins so bars touch edges nicely
    ax.margins(x=0)

    if y_lim < 0.5:
        left_labels = ["" if i == 0 else f"{y:.2f}" for i, y in enumerate(yticks)]
    else:
        left_labels = ["" if i == 0 else f"{y:.1f}" for i, y in enumerate(yticks)]
    ax.set_yticklabels(left_labels, fontsize=8)

    ax.set_xticks(range(num_bars))
    ax.set_xticklabels(benchmarks, rotation=90, ha='center', fontsize=8)
    ax.tick_params(axis='x', which='both', length=0)
    plt.xlim(left=-0.25, right=len(list_of_values) - 0.75)
    plt.ylim(top=y_lim, bottom=0.0)

    if show_ipc:
        ax2 = ax.twinx()
        ax2.set_yticks(yticks)
        ax2.set_ylim(ax.get_ylim())
        print(yticks_right)
        print(yticks)
        ax2.set_yticklabels([f"{y:.1f}" for y in yticks_right], fontsize=8)
        ax2.tick_params(axis='y', which='both', length=0)
        right_labels = ["" if i == 0 else f"{y:.2f}" for i, y in enumerate(yticks_right)]
        ax2.set_yticklabels(right_labels, fontsize=8)
        ipc_line = ax.plot(
            range(num_bars), IPCS,
            linestyle='--', linewidth=1.5, marker='^', markersize=4,
            label="IPC", color="#4bacc6"
        )
        ax2.annotate("IPC", xy=(1, 0), xycoords=("axes fraction", "axes fraction"),
                     xytext=(15, 3), textcoords="offset points",
                     ha='right', va='top', fontsize=7)

    # Build legend so it shows both color and hatch for each slot label
    legend_patches = [
        Patch(facecolor=colors[i],
              hatch=HATCHES[i % len(HATCHES)],
              edgecolor="black",
              linewidth=0.4,
              label=labels[i])
        for i in range(len(labels))
    ]

    legend_kwargs = dict(
        loc='upper center',
        bbox_to_anchor=(0.5, lh),
        frameon=False,
        ncol=5,
        fontsize=7
    )
    if num_bars > 2:
        ax.legend(handles=legend_patches, **legend_kwargs)

    ax.annotate("Slots", xy=(0, 0), xycoords=("axes fraction", "axes fraction"),
                xytext=(-22, 3), textcoords="offset points", ha='left', va='top', fontsize=7)

    fig.subplots_adjust(bottom=0.3)
    plt.savefig(f"{out_name}.svg", format="svg")
    print(f"Saved plot to {out_name}.svg")
