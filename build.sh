export AFL_PATH=~/afl-2.52b/
export PATH=$PATH:$AFL_PATH

rm -rf build
mkdir build
cd build

# cmake -E env CFLAGS="-DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=1" cmake -DARCH=x64 -DTOOLCHAIN=GCC  -DTARGET=Debug -DCRYPTO=openssl -DGCOV=ON ..
# cmake -E env CFLAGS="-DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=0" cmake -DARCH=x64 -DTOOLCHAIN=GCC  -DTARGET=Debug -DCRYPTO=openssl -DGCOV=ON ..
# cmake -E env CFLAGS="-DLIBSPDM_ENABLE_CAPABILITY_CERT_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_CHAL_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_MEAS_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_KEY_EX_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_PSK_EX_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_SET_CERTIFICATE_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_CHUNK_CAP=1 -DLIBSPDM_DEBUG_LIBSPDM_ASSERT_CONFIG=0" cmake -DARCH=x64 -DTOOLCHAIN=CLANG  -DTARGET=Release -DCRYPTO=mbedtls -DGCOV=ON ..
cmake -E env CFLAGS="-DLIBSPDM_ENABLE_CAPABILITY_CERT_CAP=0 -DLIBSPDM_ENABLE_CAPABILITY_CHAL_CAP=0 -DLIBSPDM_ENABLE_CAPABILITY_MEAS_CAP=0 -DLIBSPDM_ENABLE_CAPABILITY_KEY_EX_CAP=0 -DLIBSPDM_ENABLE_CAPABILITY_PSK_EX_CAP=0 -DLIBSPDM_ENABLE_CAPABILITY_SET_CERTIFICATE_CAP=0 -DLIBSPDM_ENABLE_CAPABILITY_CHUNK_CAP=0 -DLIBSPDM_DEBUG_LIBSPDM_ASSERT_CONFIG=0" cmake -DARCH=x64 -DTOOLCHAIN=CLANG  -DTARGET=Release -DCRYPTO=openssl -DGCOV=ON ..
# cmake -E env CFLAGS="-DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=0 -DLIBSPDM_DEBUG_LIBSPDM_ASSERT_CONFIG=0" cmake -DARCH=x64 -DTOOLCHAIN=CLANG  -DTARGET=Release -DCRYPTO=openssl -DGCOV=ON ..
# cmake -E env CFLAGS="-DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=0 -DLIBSPDM_DEBUG_LIBSPDM_ASSERT_CONFIG=0" cmake -DARCH=x64 -DTOOLCHAIN=CLANG  -DTARGET=Debug -DCRYPTO=mbedtls -DGCOV=ON ..
# cmake -E env CFLAGS="-DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=0 -DLIBSPDM_DEBUG_LIBSPDM_ASSERT_CONFIG=0" cmake -DARCH=x64 -DTOOLCHAIN=GCC  -DTARGET=Debug -DCRYPTO=mbedtls -DGCOV=ON ..
# build (ubuntu-latest, mbedtls, x64, Release, LIBFUZZER, -DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=1)

# cmake -E env CFLAGS="-DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=0" cmake -DARCH=x64 -DTOOLCHAIN=AFL -DTARGET=Debug -DCRYPTO=mbedtls -DGCOV=ON ..

# cmake -E env CFLAGS="-DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=0" cmake -DARCH=x64 -DTOOLCHAIN=LIBFUZZER  -DTARGET=Debug -DCRYPTO=mbedtls -DGCOV=ON ..
# cmake -E env CFLAGS=-"DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=1" cmake -DARCH=x64 -DTOOLCHAIN=LIBFUZZER  -DTARGET=Debug -DCRYPTO=mbedtls -DGCOV=ON ..
# cmake -E env CFLAGS="-DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=0" cmake -DARCH=x64 -DTOOLCHAIN=LIBFUZZER  -DTARGET=Release -DCRYPTO=mbedtls -DGCOV=ON ..
# cmake -E env CFLAGS="-DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=1" cmake -DARCH=x64 -DTOOLCHAIN=LIBFUZZER -DTARGET=Release -DCRYPTO=mbedtls -DGCOV=ON ..

# cmake -E env CFLAGS="-DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=0" cmake -DARCH=x64 -DTOOLCHAIN=LIBFUZZER -DTARGET=Debug -DCRYPTO=openssl -DGCOV=ON ..
# cmake -E env CFLAGS="-DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=1" cmake -DARCH=x64 -DTOOLCHAIN=LIBFUZZER -DTARGET=Debug -DCRYPTO=openssl -DGCOV=ON ..
# cmake -E env CFLAGS="-DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=0" cmake -DARCH=x64 -DTOOLCHAIN=LIBFUZZER -DTARGET=Release -DCRYPTO=openssl -DGCOV=ON ..
# cmake -E env CFLAGS="-DLIBSPDM_RECORD_TRANSCRIPT_DATA_SUPPORT=1" cmake -DARCH=x64 -DTOOLCHAIN=LIBFUZZER -DTARGET=Release -DCRYPTO=openssl -DGCOV=ON ..
make copy_sample_key
make copy_seed
make -j`nproc`
cd bin
# cp -r ./../../unit_test/fuzzing/run_initial_seed.sh
# ./run_initial_seed.sh
# bash run_initial_seed.sh

#  ./test_spdm_responder > NUL
#  ./test_spdm_requester > NUL
#  ./test_spdm_requester


# ./test_spdm_requester_get_measurements ./../../unit_test/fuzzing/seeds/test_spdm_requester_get_measurements/get_measurements.raw 
# ./test_spdm_requester_challenge ./../../unit_test/fuzzing/seeds/test_spdm_requester_challenge/challenge.raw 

#-----------------------------------------------------------------
# ./test_spdm_responder_finish_rsp ./../../unit_test/fuzzing/seeds/test_spdm_responder_finish_rsp/finish.raw 
# ./test_spdm_responder_psk_finish_rsp ./../../unit_test/fuzzing/seeds/test_spdm_responder_psk_finish_rsp/psk_finish.raw 
# ./test_spdm_responder_heartbeat_ack ./../../unit_test/fuzzing/seeds/test_spdm_responder_heartbeat_ack/heartbeat.raw 
# ./test_spdm_responder_key_update ./../../unit_test/fuzzing/seeds/test_spdm_responder_key_update/key_update.raw 
# ./test_spdm_requester_challenge ./../../unit_test/fuzzing/seeds/test_spdm_requester_challenge/challenge.raw 
# ./test_spdm_requester_finish ./../../unit_test/fuzzing/seeds/test_spdm_requester_finish/finish11.raw
# ./test_spdm_requester_finish ./../../unit_test/fuzzing/seeds/test_spdm_requester_finish/finish12.raw
# ./test_spdm_requester_key_exchange ./../../unit_test/fuzzing/seeds/test_spdm_requester_key_exchange/key_exchange11.raw
# ./test_spdm_requester_key_exchange ./../../unit_test/fuzzing/seeds/test_spdm_requester_key_exchange/key_exchange12.raw
# ./test_spdm_requester_psk_exchange ./../../unit_test/fuzzing/seeds/test_spdm_requester_psk_exchange/psk_exchange11.raw
# ./test_spdm_requester_psk_exchange ./../../unit_test/fuzzing/seeds/test_spdm_requester_psk_exchange/psk_exchange12.raw


# -------------------------------------------------------------------------------------
# ./test_spdm_responder_chunk_send_ack ./../../timeout-5c2f5f8d90015a88e7b781fcf729fff9b2957e56
# ./test_spdm_responder_csr ./../../test_spdm_responder_csr_crash 
# ./test_spdm_responder_csr ./../../crash-test_spdm_responder_csr 

# cd ../
# rm -rf coverage_log
# mkdir coverage_log
# cd coverage_log
#     lcov --capture --directory ~/libspdm_XiaoHan --output-file coverage.info
#     # lcov --capture --directory ~/libspdm_steven/libspdm --output-file coverage.info
#     genhtml coverage.info --output-directory .
