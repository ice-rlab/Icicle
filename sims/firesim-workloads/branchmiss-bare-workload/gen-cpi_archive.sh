# $1 will be the directory

RDIR=$(pwd)
cd $1
FILESITER=$(ls */uartlog*)
cd $RDIR

mkdir -p $1/branchmiss-bare0/cpi/

for i in $FILESITER
do
    cat $1/$i | grep "Base:" -A 60| grep Cycle -A 30  > $1/branchmiss-bare0/${i}.cpi
    cat $1/$i | grep "Inverted:"  > $1/branchmiss-bare0/${i}_inverted.cpi
done

wait

exit