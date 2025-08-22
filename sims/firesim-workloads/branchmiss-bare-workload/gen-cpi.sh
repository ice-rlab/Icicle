# $1 will be the directory

RDIR=$(pwd)
cd $1
echo $1
FILESITER=$(ls */uartlog*)
cd $RDIR

mkdir -p $1/branchmiss-bare0/cpi/

# out=$(basename "$(dirname $1)")

for i in $FILESITER
do
    awk '/^Base:/{flag=1; next} /^Inverted:/{flag=0} flag' $1/$i > $1/branchmiss-bare0/cpi/base.cpi

    awk '/^Inverted:/{flag=1; next} flag' $1/$i > $1/branchmiss-bare0/cpi/inverted.cpi
done


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