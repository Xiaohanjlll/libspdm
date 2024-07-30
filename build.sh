cd libspdm
mkdir build
cd build
cmake -E env CFLAG  S="-DLIBSPDM_ENABLE_CAPABILITY_CERT_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_CHAL_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_MEAS_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_KEY_EX_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_PSK_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_SET_CERT_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_CHUNK_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_MUT_AUTH_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_ENCAP_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_CSR_CAP=1 -DLIBSPDM_ENABLE_CAPABILITY_HBEAT_CAP=1 -DLIBSPDM_RESPOND_IF_READY_SUPPORT=1 -DLIBSPDM_SEND_GET_CERTIFICATE_SUPPORT=1 -DLIBSPDM_SEND_CHALLENGE_SUPPORT=1" 
cmake -G"NMake Makefiles" -DARCH=x64 -DTOOLCHAIN=VS2019 -DTARGET=Release -DCRYPTO=openssl ..
nmake copy_sample_key
nmake

#           mkdir build
#           cd build
#           cmake --version
#           cmake -E env CFLAGS="${{ matrix.configurations }} -DLIBSPDM_DEBUG_LIBSPDM_ASSERT_CONFIG=3" cmake -G"NMake Makefiles" -DARCH=${{ matrix.arch }} -DTOOLCHAIN=${{ matrix.toolchain }} -DTARGET=${{ matrix.target }} -DCRYPTO=${{ matrix.crypto }} ..
#           nmake copy_sample_key
#           nmake

# cmake -G"MSYS Makefiles" -DARCH=x64 -DTOOLCHAIN=GCC -DTARGET=Release -DCRYPTO=openssl ..
# cmake -G"MSYS Makefiles" -DARCH=x64 -DTOOLCHAIN=GCC -DTARGET=Release -DCRYPTO=openssl ..
#  cmake -G"MSYS Makefiles" -DARCH=${{ matrix.arch }} -DTOOLCHAIN=${{ matrix.toolchain }} -DTARGET=${{ matrix.target }} -DCRYPTO=${{ matrix.crypto }} ..
git reset HEAD^

# git add unit_test/test_spdm_requester/encap_digests.c
# git add unit_test/test_spdm_requester/get_digests.c
# git add unit_test/test_spdm_responder/digests.c
# git add unit_test/test_spdm_responder/encap_get_digests.c
# git commit -m "Add unit test for SPDM 1.3 DIGEST: KeyPairID and CertificateInfo " --signoff 

# git add unit_test/test_spdm_requester/get_certificate.c
# git add unit_test/test_spdm_responder/encap_get_certificate.c
# git commit -m "Enhanced unit test for SPDM 1.3 CERTIFICATE: CertModel" --signoff 
# git push origin digests -f

# git reset HEAD^
# git add unit_test/
# git commit -m "Add unit test for SPDM 1.3 CERTIFICATE: request attributes and response attributes " --signoff 
# git push origin certificate -f

git reset HEAD^

# git add unit_test/test_spdm_requester/challenge.c
# git add unit_test/test_spdm_requester/get_measurements.c
# git add unit_test/test_spdm_requester/key_exchange.c
# git add unit_test/test_spdm_responder/challenge_auth.c
# git add unit_test/test_spdm_responder/key_exchange.c
# git add unit_test/test_spdm_responder/measurements.c
# git add unit_test/test_spdm_requester/encap_challenge_auth.c
# git commit -m "add unit test for SPDM 1.3 When the corresponding key usage is not set" --signoff 
# git push origin Key_usage_bit -f



git reset HEAD^

git add unit_test/test_spdm_requester/get_measurement_extension_log.c
git add unit_test/test_spdm_requester/test_spdm_requester.c
git add unit_test/test_spdm_responder/measurement_extension_log.c
git add unit_test/test_spdm_responder/test_spdm_responder.c

git commit -m "Add unit tests for MEASUREMENT_EXTENSION_LOG" --signoff
git push origin test_MEL -f

# ---------------

git reset HEAD^

git add unit_test/test_spdm_requester/get_measurement_extension_log.c
git add unit_test/test_spdm_responder/measurement_extension_log.c
git commit -m "Add unit tests for MEASUREMENT_EXTENSION_LOG" --signoff
git push origin test_MEL_2 -f

git reset HEAD^
git add CMakeLists.txt
git add unit_test/fuzzing/fuzzing_AFL.sh
git add unit_test/fuzzing/fuzzing_AFLTurbo.sh
git add unit_test/fuzzing/fuzzing_AFLplusplus.sh
git add unit_test/fuzzing/fuzzing_LibFuzzer.sh
git add unit_test/fuzzing/oss_fuzz.sh
git add unit_test/fuzzing/run_initial_seed.sh

git add unit_test/fuzzing/seeds/test_spdm_requester_get_measurement_extension_log
git add unit_test/fuzzing/seeds/test_spdm_responder_measurement_extension_log
git add unit_test/fuzzing/test_requester/test_spdm_requester_get_measurement_extension_log
git add unit_test/fuzzing/test_responder/test_spdm_responder_measurement_extension_log

git commit -m "Add fuzz testing for MEASUREMENT_EXTENSION_LOG." --signoff
git push origin test_MEL_fuzz -f

git reset HEAD^

git add unit_test/test_spdm_responder/finish.c
git add unit_test/test_spdm_requester/finish.c
git commit -m "add unit test : Requester and Responder set HANDSHAKE_IN_THE_CLEAR_CAP to 0. " --signoff
git push origin fix_uint_test -f


git reset HEAD^
# git add unit_test/test_spdm_responder/
# git add .github\workflows\build.yml
git reset HEAD^
git add .
git commit -m "test ci " --signoff 
git push origin test_ci -f
