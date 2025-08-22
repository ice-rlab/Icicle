#!/usr/bin/python3

# system imports
import os
import argparse

# plotting package imports
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import matplotlib.ticker as mtick

# local script imports
from util import *

# labels and keys
sizes = ["Small", "Medium", "Large", "Mega", "Giga"]
size_labels = ["SmallBoom", "MediumBoom", "LargeBoom", "MegaBoom", "GigaBoom"]

configs = ["V3", "ScalarCounters", "AddWires", "DistributedCounters"]
config_labels = ["Base", "Scalar", "Adders", "Distributed"]

case_study_size = 3
case_studies = ["Base", "Correlated", "Extrapolate"]
case_study_configs = [[True, True, True], [True, True, True], [True, False, False]]
all_case_study_configs = [1,2,3]

present_metrics = [True, True, True, True, True, True, True, True]
present_legends = [True, True, True, True, True, True, True, True]
metrics = ["area", "density", "instances", "power",	"wirelength", "csr_wirelength", "csr_max_length_net", "longest_csr_path"]
metric_labels = ["Design area", "Design density", "Number of instances", "Design power", "Wirelength", "Total PMU wirelength", "Longest net in the CSR", "Longest combinational path in the CSR"]
metric_units = [" um^2", "", "", " mW", " um", " um", " um", " ns"]
metric_scale_factors = [1, 1, 1, 1, 1, 0.001, 0.001, 0.001]

# plotting parameters
config_colors = ['#9bbb59', '#c0504d', '#7030a0', '#ffc000']
config_hatches = ['x', '\\', '/', '-']
metric_lims = [[0.95, 1.05], [0.95, 1.05], [0.95, 1.05], [0.95, 1.1], [0.95, 1.2], [0.4, 2.1], [0.6, 1.9], [0.9, 1.4]]
metric_lims_case_study = [[0.95, 1.05], [0.95, 1.05], [0.95, 1.05], [0.95, 1.1], [0.95, 1.2], [0.4, 2.1], [0.6, 1.05], [0.90, 1.05]]
metric_ranges = [lim[1] - lim[0] for lim in metric_lims]
metric_ranges_case_study = [lim[1] - lim[0] for lim in metric_lims_case_study]

def get_config_name(size, config, case_study = None):
    return size + "Boom" + config + ("" if not case_study else (case_study + "CaseStudy")) + "Config"


def parse_arguments():
    parser = argparse.ArgumentParser(description="")
    parser.add_argument('path', type=str, help="CSV file")
    parser.add_argument('name', type=str,
                        help="Name of plot file or folder")
    parser.add_argument('--show_titles', action='store_true',
                        help="Display plot and axes titles")
    return parser.parse_args()


def strip_units(x):
    return float(str(x).split(' ')[0])


def present_all(args):
    # read and prepare data for numerical analysis
    print(args.path)
    df = pd.read_csv(args.path)
    df = df.set_index("Configuration", drop=True, inplace=False)
    df = df.map(strip_units)

    # Normalize the values to a 0-1 scale for plotting
    normalized_df = df.copy()
    for size in sizes:
        base_name = get_config_name(size, configs[0])
        for config in configs:
            name = get_config_name(size, config)
            for metric in metrics:
                if name in df.index and base_name in df.index:
                    normalized_df.loc[name, metric] = df.loc[name, metric] / df.loc[base_name, metric]
                else:
                    normalized_df.loc[name, metric] = 0.0

    # create plot for each metric
    for metric_i, (metric, present, legend) in enumerate(zip(metrics, present_metrics, present_legends)):
        if not present:
            continue

        # Plotting grouped bar chart
        x = np.arange(len(sizes))  # the label locations
        width = 0.20  # the width of the bars
        lim = metric_lims[metric_i]
        scale_factor = metric_scale_factors[metric_i]
        unit = metric_units[metric_i]

        fig, ax = plt.subplots(figsize=(5.5, 3))

        bars = [None for _ in configs]
        for config_i, config in enumerate(configs):
            offsets = x + (width * (-1.5 + config_i))
            vals = normalized_df.loc[
                [get_config_name(size, config) for size in sizes],
                [metric]
              ].values.flatten().tolist()

            # create data in plot
            bars[config_i] = ax.bar(offsets, vals, width,
                label=config_labels[config_i],
                color=config_colors[config_i],
                #hatch=config_hatches[config_i]
            )

            ax.yaxis.set_major_formatter(mtick.PercentFormatter(1.0, decimals=0))

            for i, (bar, value) in enumerate(zip(bars[config_i], vals)):
                if config_i == 0:
                    continue
                    # Add formatted real values
                    ax.text(
                        bar.get_x() + bar.get_width() / 2,
                        bar.get_height() + metric_ranges[metric_i] / 20,
                        format_number(df.loc[get_config_name(sizes[i], config), metric], scale_factor, unit),
                        rotation='vertical',
                        ha='center',
                        va='bottom',
                        fontweight='bold',
                        fontsize=9
                    )

                else:

                    # Calculate percentage change and determine arrow direction
                    percentage_change = (value - 1.0) * 100
                    #arrow = '\u2191' if percentage_change > 0 else '\u2193'
                    arrow = '+' if percentage_change > 0 else '-'
                    color = 'black' if percentage_change > 0 else 'black'

                    # Add percentage change text
                    ax.text(
                        bar.get_x() + width / 2,
                        bar.get_height() + metric_ranges[metric_i] / 20,
                        f'{arrow}{abs(percentage_change):.2f}%',
                        rotation='vertical',
                        ha='center',
                        va='bottom',
                        fontsize=11,
                        fontweight='normal',
                        color=color
                    )

        # Add labels, title, and legend
        if args.show_titles:
            ax.set_ylabel("Relative " + metric_labels[metric_i])
            ax.set_title(metric_labels[metric_i])
        ax.set_xticks(x, labels=sizes)
        if legend:
            ax.legend(loc='upper center', bbox_to_anchor=(
                0.5, 1.01), frameon=False, ncol=5, fontsize=10)

        ax.spines[['right', 'top']].set_visible(False)
        ax.grid(axis="y", linestyle=':', alpha=1.0)
        ax.set_axisbelow(True)

        plt.tight_layout()
        plt.ylim(lim)
        plt.savefig(f"{args.name}-{metric}.svg", format="svg")


def present_casestudies(args):
    # read and prepare data for numerical analysis
    print(args.path)
    df = pd.read_csv(args.path)
    df = df.set_index("Configuration", drop=True, inplace=False)
    df = df.map(strip_units)

    # Normalize the values to a 0-1 scale for plotting
    normalized_df = df.copy()
    for cs_i, (cs, cs_configs) in enumerate(zip(case_studies, case_study_configs)):
        for i, (present, cfg_i) in enumerate(zip(cs_configs, all_case_study_configs)):
            config = configs[cfg_i]
            base_name = get_config_name(sizes[case_study_size], config, case_studies[0])
            name = get_config_name(sizes[case_study_size], config, cs)
            if present:
                for metric in metrics:
                    normalized_df.loc[name, metric] = df.loc[name, metric] / df.loc[base_name, metric]
            else:
                for metric in metrics:
                    normalized_df.loc[name, metric] = 0.0

    # create plot for each metric
    for metric_i, metric in enumerate(metrics):

        # Plotting grouped bar chart
        x = np.arange(len(all_case_study_configs))  # the label locations
        width = 0.20  # the width of the bars
        lim = metric_lims_case_study[metric_i]
        scale_factor = metric_scale_factors[metric_i]
        unit = metric_units[metric_i]

        fig, ax = plt.subplots(figsize=(4, 3))

        bars = [None for _ in configs]
        for cs_i, (cs, cs_configs) in enumerate(zip(case_studies, case_study_configs)):
            offsets = x + (width * (-1 + cs_i))
            vals = normalized_df.loc[
                [get_config_name(sizes[case_study_size], configs[config], cs) for config in all_case_study_configs],
                [metric]
              ].values.flatten().tolist()

            # create data in plot
            bars[cs_i] = ax.bar(offsets, vals, width,
                label=config_labels[cs_i],
                color=config_colors[cs_i],
                #hatch=config_hatches[cs_i]
            )

            ax.yaxis.set_major_formatter(mtick.PercentFormatter(1.0))

            for i, (bar, value, cfg_i) in enumerate(zip(bars[cs_i], vals, all_case_study_configs)):
                if not cs_configs[i]:
                    continue
                config = configs[cfg_i]

                if cs_i == 0:
                    continue
                    # Add formatted real values
                    ax.text(
                        bar.get_x() + width / 2,
                        bar.get_height() + metric_ranges_case_study[metric_i] / 20,
                        format_number(df.loc[get_config_name(sizes[case_study_size], config, cs), metric], scale_factor, unit),
                        rotation='vertical',
                        ha='center',
                        va='bottom',
                        fontweight='bold',
                        fontsize=9
                    )

                else:

                    # Calculate percentage change and determine arrow direction
                    percentage_change = (value - 1.0) * 100
                    #arrow = '\u2191' if percentage_change > 0 else '\u2193'
                    arrow = '+' if percentage_change > 0 else '-'
                    color = 'black' if percentage_change > 0 else 'black'

                    # Add percentage change text
                    ax.text(
                        bar.get_x() + width / 2,
                        bar.get_height() + metric_ranges_case_study[metric_i] / 20,
                        f'{arrow}{abs(percentage_change):.2f}%',
                        rotation='vertical',
                        ha='center',
                        va='bottom',
                        fontsize=9,
                        fontweight='normal',
                        color=color
                    )

        # Add labels, title, and legend
        if args.show_titles:
            ax.set_ylabel("Relative " + metric_labels[metric_i])
            ax.set_title(metric_labels[metric_i])
        ax.set_xticks(x, labels=[config_labels[i] for i in all_case_study_configs])
        ax.legend(loc='upper center', bbox_to_anchor=(
            0.5, 1.01), frameon=False, ncol=5, fontsize=10,
            labels=case_studies)

        ax.spines[['right', 'top']].set_visible(False)
        ax.grid(axis="y", linestyle=':', alpha=1.0)
        ax.set_axisbelow(True)

        plt.tight_layout()
        plt.ylim(lim)
        plt.savefig(f"{args.name}-case-{metric}.svg", format="svg")


if __name__ == "__main__":
    args = parse_arguments()
    present_all(args)
    #present_casestudies(args)
