# $1 will be the directory

echo "Hello from post run"

RDIR=$(pwd)
cd $1
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