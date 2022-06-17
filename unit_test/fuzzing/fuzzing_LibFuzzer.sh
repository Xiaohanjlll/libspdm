#!/bin/bash

# Before run this script, please install LLVM with: sudo apt install llvm, and install CLANG with: sudo apt install clang.
# If command 'screen' not found, please install with: sudo apt install screen.
# You can collect Code Coverage in Linux with LibFuzzer and llvm-cov.

if [ "$#" -ne "3" ];then
    echo "Usage: $0 <CRYPTO> <GCOV> <duration>"
    echo "<CRYPTO> means selected Crypto library: mbedtls or openssl"
    echo "<GCOV> means enable Code Coverage or not: ON or OFF"
    echo "<duration> means the duration of every program keep fuzzing: NUMBER seconds"
    #read -p "press enter to exit"
    exit
fi

if [[ $1 = "mbedtls" || $1 = "openssl" ]]; then
    echo "<CRYPTO> parameter is $1"
else
    echo "Usage: $0 <CRYPTO> <GCOV> <duration>"
    echo "<CRYPTO> means selected Crypto library: mbedtls or openssl"
    echo "<GCOV> means enable Code Coverage or not: ON or OFF"
    echo "<duration> means the duration of every program keep fuzzing: NUMBER seconds"
    exit
fi

if [[ $2 = "ON" || $2 = "OFF" ]]; then
    echo "<GCOV> parameter is $2"
else
    echo "Usage: $0 <CRYPTO> <GCOV> <duration>"
    echo "<CRYPTO> means selected Crypto library: mbedtls or openssl"
    echo "<GCOV> means enable Code Coverage or not: ON or OFF"
    echo "<duration> means the duration of every program keep fuzzing: NUMBER seconds"
    exit
fi

echo "<duration> parameter is $3"
export duration=$3

echo "start fuzzing in Linux with LLVM LibFuzzer"

pkill screen

export script_path="$(cd "$(dirname $0)";pwd)"
export libspdm_path=$script_path/../..
export fuzzing_path=$libspdm_path/unit_test/fuzzing
export fuzzing_seeds=$libspdm_path/unit_test/fuzzing/seeds


if [[ $PWD!=$libspdm_path ]];then
    pushd $libspdm_path
    latest_hash=`git log --pretty="%h" -1`
    export fuzzing_out=$libspdm_path/unit_test/fuzzing/out_libfuzz_$1_$latest_hash
    export build_fuzzing=build_libfuzz_$1_$latest_hash
fi

if [ ! -d "$fuzzing_out" ];then
    mkdir $fuzzing_out
fi

rm -rf $fuzzing_out/*

if [ -d "$build_fuzzing" ];then
    rm -rf $build_fuzzing
fi

mkdir $build_fuzzing
pushd $build_fuzzing

cmake -DARCH=x64 -DTOOLCHAIN=LIBFUZZER -DTARGET=Release -DCRYPTO=$1 -DGCOV=$2 ..
make copy_sample_key
make
pushd bin

cmds=(
test_spdm_responder_chunk_get
)
object_parameters=()
cp -r $fuzzing_seeds ./
for ((i=0;i<${#cmds[*]};i++))
do
    object_parameters[${#object_parameters[*]}]="-object ${cmds[$i]}"
    echo ${cmds[$i]}
    mkdir $fuzzing_out/${cmds[$i]}
    screen -ls | grep ${cmds[$i]}
    if [[ $? -ne 0 ]]
    then
    screen -dmS ${cmds[$i]}
    fi
    screen -S ${cmds[$i]} -p 0 -X stuff "./${cmds[$i]} ./seeds/${cmds[$i]} -rss_limit_mb=0 -timeout=10 -artifact_prefix=$fuzzing_out/${cmds[$i]}/"
    screen -S ${cmds[$i]} -p 0 -X stuff $'\n'
    sleep $duration
    screen -S ${cmds[$i]} -X quit
    sleep 5
done

if [[ $2 = "ON" ]]; then
    for ((i=0;i<${#cmds[*]};i++))
    do
        LLVM_PROFILE_FILE="${cmds[$i]}.profraw" ./${cmds[$i]} ./seeds/${cmds[$i]}/* -timeout=30
    done
    llvm-profdata merge -o coverage.prof *.profraw
    llvm-cov export -format lcov -instr-profile coverage.prof ${object_parameters[*]} > coverage.info
    genhtml coverage.info --output-directory $fuzzing_out/coverage_log
fi

function walk_dir(){
    for file in `ls $1`
    do
        libfuzzer_banner=$file
        leak=`find $1"/"$file -name '*leak*' |wc -l`
        timeout=`find $1"/"$file -name '*timeout*' |wc -l`
        crash=`find $1"/"$file -name '*crash*' |wc -l`
        echo $libfuzzer_banner,$leak,$timeout,$crash >> $fuzzing_out"/SummaryList.csv"
    done
}
echo libfuzzer_banner,leak,timeout,crash > $fuzzing_out"/SummaryList.csv"
walk_dir $fuzzing_out

sed -i '/SummaryList.csv/d' $fuzzing_out"/SummaryList.csv"
sed -i '/coverage_log/d' $fuzzing_out"/SummaryList.csv"