# $1 will be the directory

RDIR=$(pwd)
cd $1
echo $1
FILESITER=$(ls */uartlog*)
cd $RDIR

# CPI 
mkdir -p $1/dhrystone-bare0/cpi/

out=$(basename "$(dirname $1)")

for i in $FILESITER
do
   awk '/scounteren:/ {found=1; next} found' $1/$i> $1/dhrystone-bare0/cpi/dhrystone.cpi
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