set -x

LOG_DIR=../benchResults
FLAG_NAMES=('vanilla' 'all' 'some' 'none')
FLAG_STRS=('-fno-new-blocklayout -fvanilla-blocklayout' '-fnew-blocklayout -fcfg-weights=callWeight=310' '-fnew-blocklayout -fcfg-weights=callWeight=300' '-fnew-blocklayout -fcfg-weights=callWeight=-900')
mkdir -p "$LOG_DIR"


if [ -z ${1} ]; then
    echo "Please specify a compiler: $0 <HC>"
    #exit
    HC="C:\\ghc\\msys64\\home\\Andi\\ghc_layout\\inplace\\bin\\ghc-stage2.exe"
else
    HC="$1"
fi

if [ ! -d "megaparsec" ]; then
  git clone https://github.com/mrkkrp/megaparsec.git
  sed -i "1i{-# LANGUAGE UndecidableInstances  #-}" megaparsec/Text/Megaparsec/Error.hs
  #sed "s/name: containers/name: containers-bench/" containers/containers.cabal  -i
fi
#cd aeson
#cabal new-update

if [ ! -d "primitive" ]; then
  git clone https://github.com/haskell/primitive.git
  cd primitive
  git reset --hard a2af610
  cd ..
fi

if [ ! -d "vector-algorithms" ]; then
  curl https://hub.darcs.net/dolio/vector-algorithms/dist --output vector-algorithms.zip
  unzip vector-algorithms.zip
  sed "s/Odph/O2/" -i vector-algorithms/vector-algorithms.cabal
fi

cabal new-update

#Build with different flags

DIR_NAME=${PWD##*/}
COMPILER_NAME=${DIR_NAME#aeson_}
BENCHMARKS="bench-speed bench-memory"
# STORE_DIR=~/.store_${COMPILER_NAME}
# STORE="--store-dir=${STORE_DIR} "
for i in {0..3};
do
    HC_FLAGS=${FLAG_STRS[$i]}
    echo "Configure for ${FLAG_NAMES[$i]} - ${HC_FLAGS}"
    cabal new-configure all -w "$HC" --allow-newer=base,primitive,criterion,containers,vector --ghc-options="$HC_FLAGS" --enable-benchmarks
    cabal new-build all -j4

    for benchmark in ${BENCHMARKS};
    do
        echo "Benchmark: $benchmark"
        cabal new-run  "$benchmark" -- --csv "$LOG_DIR/${COMPILER_NAME}.${FLAG_NAMES[$i]}.${benchmark}.csv"
    done
done