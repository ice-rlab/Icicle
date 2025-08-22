# $1 will be the directory

RDIR=$(pwd)
cd $1
echo $1
FILESITER=$(ls */uartlog*)
cd $RDIR

# CPI 
mkdir -p $1/qsort_riscv_tests-bare0/cpi/

out=$(basename "$(dirname $1)")

for i in $FILESITER
do
    cat $1/$i | tail -n 60 | head -n 46 > $1/qsort_riscv_tests-bare0/cpi/qsort.cpi
done

wait

# Trace
cd $1
FILESITER=$(ls */TRACEFILE*)
cd $RDIR

for i in $FILESITER
do
    echo $i
    echo "./../../../../../../sims/firesim-trace/bin/trace_decoder $1/$i"
    ../../../../../../../sims/firesim-trace/bin/trace_decoder $1/$i
    zstd $1/$i.decoded
done

wait


exit