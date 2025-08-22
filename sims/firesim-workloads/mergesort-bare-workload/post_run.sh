# $1 will be the directory

RDIR=$(pwd)
cd $1
echo $1
FILESITER=$(ls */uartlog*)
cd $RDIR

# CPI 
mkdir -p $1/mergesort-bare0/cpi/

out=$(basename "$(dirname $1)")

for i in $FILESITER
do
    cat $1/$i | tail -n 60 | head -n 46 > $1/mergesort-bare0/cpi/mergesort.cpi
done
wait


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

# cd $1
# # Trace
# # FILESITER=$(ls TRACEFILE*)
# cd $RDIR

# echo $(pwd)

# echo $i
# echo "./../../../../../../sims/firesim-trace/bin/trace_decoder $RDIR/mergeort-bare0/TRACEFILE-C0"
# ../../../../../../../sims/firesim-trace/bin/trace_decoder $RDIR/mergeort-bare0/TRACEFILE-C0
# zstd $RDIR/mergeort-bare0/TRACEFILE-C0.decoded
# wait
# exit