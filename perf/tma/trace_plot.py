import numpy as np
import matplotlib.pyplot as plt

from plot_defs import *


def create_binary_heatmap(df, out_name="binary_heatmap"):
    """
    df : pandas.DataFrame
      - Index is taken as the “cycle” axis (if it’s numeric or RangeIndex).
      - Columns are the features/events (boolean or 0/1).
    """
    data = df.astype(int).values
    cycle_values   = df.index.to_numpy()
    column_labels  = df.columns.tolist()
    time_indices, feature_indices = np.where(data == 1)

    row_height = 0.3
    fig_height = max(2, row_height * len(column_labels))
    fig, ax = plt.subplots(figsize=(6, fig_height))


    ax.set_yticks(np.arange(len(column_labels)))
    ax.set_yticklabels(column_labels)

    num_ticks     = 10
    tick_inds     = np.linspace(0, len(cycle_values) - 1, num=num_ticks, dtype=int)
    tick_labels   = cycle_values[tick_inds]
    ax.set_xticks(tick_inds)
    ax.set_xticklabels(tick_labels, rotation=45)
    ax.set_xlabel("Cycle")

    ax.scatter(
        time_indices, feature_indices,
        s=6,                # smaller dots
        marker='o',
        color='purple',     # or a hex like '#7B61FF'
        edgecolors='none',
        zorder=3
    )
    ax.text(-0.05 * len(cycle_values), -1,
            "Events", rotation=0, ha='left', va='bottom',
            fontsize=10, transform=ax.transData)

    ax.set_xlim(0, len(cycle_values) - 1)
    ax.set_ylim(-0.5, len(column_labels) - 0.5)
    ax.invert_yaxis()

    plt.tight_layout()
    plt.savefig(f"{out_name}.svg", format="svg", bbox_inches='tight')
    print(f"Saved plot to {out_name}.svg")