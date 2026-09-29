1. git clone https://github.com/mparel/postman-test.git
2. cd postman-test
3. npm install
4. Set credentials: 
    export API_USERNAME='the-valid-api-username'
    export API_PASSWORD='the-valid-api-password'
5. Test your local installation: npx newman --version
6. To run the specific test or all tests, type:
    npm run test:auth => (POST /token)
    npm run test:get-users => (GET /users)
    npm run test:post-users => (POST /users)
    npm run test:put-users => (PUT /users)
    npm run test:get-user-by-id => (GET /user by id)
    npm run test:delete-users => (DELETE /user by id)
    npm run test => (run all tests)
