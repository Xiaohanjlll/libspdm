/**
 *  Copyright Notice:
 *  Copyright 2024 DMTF. All rights reserved.
 *  License: BSD 3-Clause License. For full text see link: https://github.com/DMTF/libspdm/blob/main/LICENSE.md
 **/

#include "spdm_unit_test.h"
#include "internal/libspdm_responder_lib.h"
#include "internal/libspdm_requester_lib.h"

#if LIBSPDM_ENABLE_CAPABILITY_GET_KEY_PAIR_INFO_CAP

spdm_get_key_pair_info_request_t m_libspdm_get_key_pair_info_request1 = {
    { SPDM_MESSAGE_VERSION_13, SPDM_GET_KEY_PAIR_INFO, 0, 0 },
    1
};
size_t m_libspdm_get_key_pair_info_request1_size = sizeof(m_libspdm_get_key_pair_info_request1);

/**
 * Test 1: Successful response to get key pair info with key pair id 1
 * Expected Behavior: get a RETURN_SUCCESS return code, and correct response message size and fields
 **/
void libspdm_test_responder_key_pair_info_case1(void **state)
{
    libspdm_return_t status;
    libspdm_test_context_t *spdm_test_context;
    libspdm_context_t *spdm_context;
    size_t response_size;
    uint8_t response[LIBSPDM_MAX_SPDM_MSG_SIZE];
    spdm_key_pair_info_response_t *spdm_response;
    uint8_t key_pair_id;
    uint16_t public_key_info_len;
    uint8_t public_key_info_rsa2048[] = {0x30, 0x0D, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86, 0xF7,
                                         0x0D, 0x01, 0x01, 0x01, 0x05, 0x00};

    spdm_test_context = *state;
    spdm_context = spdm_test_context->spdm_context;
    spdm_test_context->case_id = 0x1;
    spdm_context->connection_info.version = SPDM_MESSAGE_VERSION_13 <<
                                            SPDM_VERSION_NUMBER_SHIFT_BIT;
    spdm_context->connection_info.connection_state =
        LIBSPDM_CONNECTION_STATE_AUTHENTICATED;
    spdm_context->local_context.capability.flags |=
        SPDM_GET_CAPABILITIES_RESPONSE_FLAGS_GET_KEY_PAIR_INFO_CAP;

    key_pair_id = 1;
    spdm_context->local_context.total_key_pairs = key_pair_id;

    spdm_context->local_context.key_pair_info[key_pair_id -
                                              1].capabilities = SPDM_KEY_PAIR_CAP_GEN_KEY_CAP;
    spdm_context->local_context.key_pair_info[key_pair_id -
                                              1].key_usage_capabilities =
        SPDM_KEY_USAGE_BIT_MASK_KEY_EX_USE;
    spdm_context->local_context.key_pair_info[key_pair_id -
                                              1].current_key_usage =
        SPDM_KEY_USAGE_BIT_MASK_KEY_EX_USE;
    spdm_context->local_context.key_pair_info[key_pair_id -
                                              1].asym_algo_capabilities =
        SPDM_KEY_PAIR_ASYM_ALGO_CAP_RSA2048;
    spdm_context->local_context.key_pair_info[key_pair_id -
                                              1].current_asym_algo =
        SPDM_KEY_PAIR_ASYM_ALGO_CAP_RSA2048;
    spdm_context->local_context.key_pair_info[key_pair_id - 1].assoc_cert_slot_mask = 0x01;


    public_key_info_len = sizeof(public_key_info_rsa2048);
    spdm_context->local_context.key_pair_info[key_pair_id -
                                              1].public_key_info_len = public_key_info_len;
    libspdm_copy_mem(spdm_context->local_context.key_pair_info[key_pair_id - 1].public_key_info,
                     public_key_info_len,
                     public_key_info_rsa2048,
                     public_key_info_len);

    response_size = sizeof(response);

    status = libspdm_get_response_key_pair_info(
        spdm_context, m_libspdm_get_key_pair_info_request1_size,
        &m_libspdm_get_key_pair_info_request1, &response_size, response);
    assert_int_equal(status, LIBSPDM_STATUS_SUCCESS);
    assert_int_equal(response_size,
                     sizeof(spdm_key_pair_info_response_t) + public_key_info_len);
    spdm_response = (void *)response;
    assert_int_equal(spdm_response->header.request_response_code,
                     SPDM_KEY_PAIR_INFO);
    assert_int_equal(spdm_response->key_pair_id,
                     1);
}

void libspdm_test_responder_key_pair_info_case2(void **state)
{
    libspdm_return_t status;
    libspdm_test_context_t *spdm_test_context;
    libspdm_context_t *spdm_context;
    size_t response_size;
    uint8_t response[LIBSPDM_MAX_SPDM_MSG_SIZE];
    spdm_key_pair_info_response_t *spdm_response;
    uint8_t key_pair_id;

    spdm_test_context = *state;
    spdm_context = spdm_test_context->spdm_context;
    spdm_test_context->case_id = 0x2;
    spdm_context->connection_info.version = SPDM_MESSAGE_VERSION_13 <<
                                            SPDM_VERSION_NUMBER_SHIFT_BIT;
    spdm_context->connection_info.connection_state =
        LIBSPDM_CONNECTION_STATE_AUTHENTICATED;
    spdm_context->local_context.capability.flags |=
        SPDM_GET_CAPABILITIES_RESPONSE_FLAGS_GET_KEY_PAIR_INFO_CAP;

    /* An SPDM endpoint shall contain KeyPairID s starting from 1 to TotalKeyPairs inclusive and without gaps.
     * KeyPairID is set to 0.*/
    key_pair_id = 0;
    m_libspdm_get_key_pair_info_request1.key_pair_id = key_pair_id;

    spdm_context->local_context.total_key_pairs = 1;

    response_size = sizeof(response);

    status = libspdm_get_response_key_pair_info(
        spdm_context, m_libspdm_get_key_pair_info_request1_size,
        &m_libspdm_get_key_pair_info_request1, &response_size, response);
    assert_int_equal(status, LIBSPDM_STATUS_SUCCESS);
    spdm_response = (void *)response;
    assert_int_equal(spdm_response->header.request_response_code,
                     SPDM_ERROR);
    assert_int_equal(spdm_response->header.param1, SPDM_ERROR_CODE_INVALID_REQUEST);
    assert_int_equal(spdm_response->header.param2, 0);
}

void libspdm_test_responder_key_pair_info_case3(void **state)
{
    libspdm_return_t status;
    libspdm_test_context_t *spdm_test_context;
    libspdm_context_t *spdm_context;
    size_t response_size;
    uint8_t response[LIBSPDM_MAX_SPDM_MSG_SIZE];
    spdm_key_pair_info_response_t *spdm_response;
    uint8_t key_pair_id;

    spdm_test_context = *state;
    spdm_context = spdm_test_context->spdm_context;
    spdm_test_context->case_id = 0x3;
    spdm_context->connection_info.version = SPDM_MESSAGE_VERSION_13 <<
                                            SPDM_VERSION_NUMBER_SHIFT_BIT;
    spdm_context->connection_info.connection_state =
        LIBSPDM_CONNECTION_STATE_AUTHENTICATED;
    spdm_context->local_context.capability.flags |=
        SPDM_GET_CAPABILITIES_RESPONSE_FLAGS_GET_KEY_PAIR_INFO_CAP;

    /* key_pair_id > total_key_pairs*/
    key_pair_id = 2;
    m_libspdm_get_key_pair_info_request1.key_pair_id = key_pair_id;
    spdm_context->local_context.total_key_pairs = 1;

    response_size = sizeof(response);

    status = libspdm_get_response_key_pair_info(
        spdm_context, m_libspdm_get_key_pair_info_request1_size,
        &m_libspdm_get_key_pair_info_request1, &response_size, response);
    assert_int_equal(status, LIBSPDM_STATUS_SUCCESS);
    spdm_response = (void *)response;
    assert_int_equal(spdm_response->header.request_response_code,
                     SPDM_ERROR);
    assert_int_equal(spdm_response->header.param1, SPDM_ERROR_CODE_INVALID_REQUEST);
    assert_int_equal(spdm_response->header.param2, 0);
}


void libspdm_test_responder_key_pair_info_case4(void **state)
{
    libspdm_return_t status;
    libspdm_test_context_t *spdm_test_context;
    libspdm_context_t *spdm_context;
    size_t response_size;
    uint8_t response[LIBSPDM_MAX_SPDM_MSG_SIZE];
    spdm_key_pair_info_response_t *spdm_response;
    uint8_t key_pair_id;

    spdm_test_context = *state;
    spdm_context = spdm_test_context->spdm_context;
    spdm_test_context->case_id = 0x4;
    spdm_context->connection_info.version = SPDM_MESSAGE_VERSION_13 <<
                                            SPDM_VERSION_NUMBER_SHIFT_BIT;
    spdm_context->connection_info.connection_state =
        LIBSPDM_CONNECTION_STATE_AUTHENTICATED;
    /* not set KEY_PAIR_INFO*/
    spdm_context->local_context.capability.flags &=
        ~SPDM_GET_CAPABILITIES_RESPONSE_FLAGS_GET_KEY_PAIR_INFO_CAP;

    key_pair_id = 1;
    m_libspdm_get_key_pair_info_request1.key_pair_id = key_pair_id;

    spdm_context->local_context.total_key_pairs = key_pair_id;

    response_size = sizeof(response);

    status = libspdm_get_response_key_pair_info(
        spdm_context, m_libspdm_get_key_pair_info_request1_size,
        &m_libspdm_get_key_pair_info_request1, &response_size, response);
    assert_int_equal(status, LIBSPDM_STATUS_SUCCESS);
    spdm_response = (void *)response;
    assert_int_equal(spdm_response->header.request_response_code,
                     SPDM_ERROR);
    assert_int_equal(spdm_response->header.param1, SPDM_ERROR_CODE_UNSUPPORTED_REQUEST);
    assert_int_equal(spdm_response->header.param2, SPDM_GET_KEY_PAIR_INFO);
}


libspdm_test_context_t m_libspdm_responder_key_pair_info_test_context = {
    LIBSPDM_TEST_CONTEXT_VERSION,
    false,
};

int libspdm_responder_key_pair_info_test_main(void)
{
    const struct CMUnitTest spdm_responder_key_pair_info_tests[] = {
        /* Success Case to get key pair info*/
        cmocka_unit_test(libspdm_test_responder_key_pair_info_case1),
        /* The KeyPairID is at least 1 , KeyPairID is set to 0.*/
        cmocka_unit_test(libspdm_test_responder_key_pair_info_case2),
        /* KeyPairID > total_key_pairs*/
        cmocka_unit_test(libspdm_test_responder_key_pair_info_case3),
        /* capability not set KEY_PAIR_INFO*/
        cmocka_unit_test(libspdm_test_responder_key_pair_info_case4),
    };

    libspdm_setup_test_context(&m_libspdm_responder_key_pair_info_test_context);

    return cmocka_run_group_tests(spdm_responder_key_pair_info_tests,
                                  libspdm_unit_test_group_setup,
                                  libspdm_unit_test_group_teardown);
}

#endif /* LIBSPDM_ENABLE_CAPABILITY_GET_KEY_PAIR_INFO_CAP*/
