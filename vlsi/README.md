
# VLSI flow quickstart

We demonstrate the basic reporting only for the Mega size of
BOOM but the referenced scripts can easily apply to any of the other sizes.

First, login to your machine, `ssh -X -Y <user>@<ip> -p <port>`. We will provide these details through HotCRP to the artifact evaluators. Then, run (you can do this inside a `tmux new -s artifact` environment):

```
cd riscv-performance-characterization
source ./env.sh # 'source env.sh' does not work on this machine
make -C vlsi help # This prints out the make targets available in your environment
```

The following command iterates through each of the implemented Mega BOOM configurations
and produces metrics. This command will take upwards of an hour as Innovus must load the
implemented designs before producing power and timing models.
```
bash ./vlsi/scripts/kick_the_tires.sh
```

To examine the results, you can view the statistics table (`data/stats.csv`) and look at
the plots. For example, we see how total power remains stable following our designs for
the adders and distributed counters by running the following command. These results
correspond to Figure 9(a). In the provided implementations, the Adders configuration
introduces a 2.5% overhead of power (46.014 mW versus 44.856 mW) while the Distributed
configuration reduces implementation power by 0.9% (44.472 mW versus 44.856 mW) compared
to the baseline (MegaBoomV3Config).

```awk -F, '{print $1,$5}' ./vlsi/data/stats.csv```

Similarly, we view the tradeoff of longest combinational path in the PMU with the
following command. These results correspond to Figure 9(b). The Distributed configuration
has a 17.4% shorter critical path (3777.000 ns) when compared to the Adders configuration
(4574.201 ns).

```awk -F, '{print $1,$9}' ./vlsi/data/stats.csv```

If you wish to view the plots (`ls data/*.svg`), you `scp` on your local machine. Run the
following commands to copy the images then you can view them however you wish.

```
# Figure 9(a)
scp -p <port> <user>@<ip>:~/riscv-performance-characterization/vlsi/data/vlsi-power.svg .
# Figure 9(b)
scp -p <port> <user>@<ip>:~/riscv-performance-characterization/vlsi/data/vlsi-longest_csr_path.svg .
```
