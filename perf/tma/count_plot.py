import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import math
import os
import argparse

from plot_defs import *




def create_count_plot(out_name, data,  width: float = 5.5, height: float = 4.5, lh=1.08, ylim=None):
    records = {}
    for bench, metrics in data.items():
        combined = {}
        for metric, vals in metrics.items():
            for i, v in enumerate(vals):
                combined[f"{metric}{i}"] = v
        records[bench] = combined

    df = pd.DataFrame.from_dict(records, orient='index').fillna(0)

    fig, ax = plt.subplots(figsize=(12, 6))
    bars = df.plot(kind='bar', ax=ax, width=0.8)

    ax.set_xlabel('Benchmark')
    ax.set_ylabel('Normalized Value')
    ax.set_title('FetchBubble and UopsIssued per Lane')
    ax.legend(title='Metric-Lane', bbox_to_anchor=(1.05, 1), loc='upper left')

    for container in ax.containers:
        ax.bar_label(container, fmt='%.2f', label_type='edge', padding=2)

    plt.xticks(rotation=45, ha='right')
    