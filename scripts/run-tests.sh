#!/bin/bash

# --------------------------------
# Configuration
# --------------------------------
COLLECTION="collection/postman-test.collectionv2-1.json"
BASE_ENV="environment/postman-test.postman_environment.json"
RUNTIME_ENV="environment/runtime.postman_environment.json"

# --------------------------------
# Validate required secrets
# --------------------------------
if [ -z "$API_USERNAME" ] || [ -z "$API_PASSWORD" ]; then
    echo "ERROR: API_USERNAME and API_PASSWORD must be set."
    exit 1
fi

# -------------------------------
# Generate a fresh access token
# -------------------------------
setup_auth() {
    echo ""
    echo "======================================"
    echo " Generating fresh access token"
    echo "======================================"

    newman run "$COLLECTION" \
        -e "$BASE_ENV" \
        --env-var "validusername=$API_USERNAME" \
        --env-var "validpassword=$API_PASSWORD" \
        --folder "00 - Setup" \
        --export-environment "$RUNTIME_ENV"

    if [ $? -ne 0 ]; then
        echo "Authentication setup failed."
        exit 1
    fi
}

# -------------------------------
# Authentication test suite
# -------------------------------
run_auth() {
    echo ""
    echo "======================================"
    echo " Running Authentication Tests"
    echo "======================================"

    newman run "$COLLECTION" \
        -e "$BASE_ENV" \
        --env-var "validusername=$API_USERNAME" \
        --env-var "validpassword=$API_PASSWORD" \
        -d "test-data/authentication-test-data.json" \
        --folder "01 - Authentication"
}

# -------------------------------
# GET /users
# -------------------------------
run_get_users() {
    setup_auth

    newman run "$COLLECTION" \
        -e "$RUNTIME_ENV" \
        -d "test-data/get-users-test-data.json" \
        --folder "02 - GET Users"
}

# -------------------------------
# POST /users
# -------------------------------
run_post_users() {
    setup_auth

    newman run "$COLLECTION" \
        -e "$RUNTIME_ENV" \
        -d "test-data/post-users-test-data.json" \
        --folder "03 - POST Users"
}

# -------------------------------
# PUT /users
# -------------------------------
run_put_users() {
    setup_auth

    newman run "$COLLECTION" \
        -e "$RUNTIME_ENV" \
        -d "test-data/put-users-test-data.json" \
        --folder "04 - PUT Users"
}

# -------------------------------
# GET /users/{id}
# -------------------------------
run_get_user_by_id() {
    setup_auth

    newman run "$COLLECTION" \
        -e "$RUNTIME_ENV" \
        -d "test-data/get-users-by-id-test-data.json" \
        --folder "05 - GET User By ID"
}

# -------------------------------
# DELETE /users/{id}
# -------------------------------
run_delete_users() {
    setup_auth

    newman run "$COLLECTION" \
        -e "$RUNTIME_ENV" \
        -d "test-data/delete-users-by-id-test-data.json" \
        --folder "06 - DELETE User"
}

# -------------------------------
# Run all suites
# -------------------------------
run_all() {
    run_auth

    setup_auth

    newman run "$COLLECTION" \
        -e "$RUNTIME_ENV" \
        -d "test-data/get-users-test-data.json" \
        --folder "02 - GET Users"

    newman run "$COLLECTION" \
        -e "$RUNTIME_ENV" \
        -d "test-data/post-users-test-data.json" \
        --folder "03 - POST Users"

    newman run "$COLLECTION" \
        -e "$RUNTIME_ENV" \
        -d "test-data/put-users-test-data.json" \
        --folder "04 - PUT Users"

    newman run "$COLLECTION" \
        -e "$RUNTIME_ENV" \
        -d "test-data/get-users-by-id-test-data.json" \
        --folder "05 - GET User By ID"

    newman run "$COLLECTION" \
        -e "$RUNTIME_ENV" \
        -d "test-data/delete-users-by-id-test-data.json" \
        --folder "06 - DELETE User"
}

case "$1" in
    auth)
        run_auth
        ;;
    get-users)
        run_get_users
        ;;
    post-users)
        run_post_users
        ;;
    put-users)
        run_put_users
        ;;
    get-user-by-id)
        run_get_user_by_id
        ;;
    delete-users)
        run_delete_users
        ;;
    all)
        run_all
        ;;
    *)
        echo ""
        echo "Usage: ./scripts/run-tests.sh [suite]"
        echo ""
        echo "Available suites:"
        echo "  auth"
        echo "  get-users"
        echo "  post-users"
        echo "  put-users"
        echo "  get-user-by-id"
        echo "  delete-users"
        echo "  all"
        echo ""
        exit 1
        ;;
esac