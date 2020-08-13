# Authenticator
This application serves as a authenticator to provide a fast and secure API for authenticate user.
It based on Ruby on Rails and redis.

## API
### Register
```
POST /user/register
{
    "name": "user1", 
    "password": "abcdABCD!233"
}
```
Response
```
{
    "message": "User has been created.",
    "status": 200
}
```
### Login
```
{
    "name": "user1", 
    "password": "abcdABCD!233"
}
```
Response
```
{
    "error": "User login successfully.",
    "status": 200
}
```
## Redis Storage
I use redis key-value for storing user info. The key is for username and the value is hashed password.

## Security
I use bcrypt for security. It will help to store hashed and salted password in redis.

## Test Cases
| Description                                                    | Request                                       | Status Code | Response                                                                           | Note |
|----------------------------------------------------------------|-----------------------------------------------|-------------|------------------------------------------------------------------------------------|------|
| Register a new user                                            | {"name": "user1", "password": "abcdABCD!233"} | 200         | {"message": "User has been created.", "status": 200}                               |      |
| Register a user with existing username                         | {"name": "user1", "password": "abcdABCD!233"} | 422         | {"error": "User exists. Please use another username", "status": 422}               |      |
| Register a user with empty username                            | {"name": "", "password": "abcdABCD!233"}      | 422         | {"error":"Empty username. ","status":422}                                          |      |
| Register a user with empty password                            | {"name": "user1", "password": ""}             | 422         | {"error":" Empty password.","status":422}                                          |      |
| Register a user with password length less than 8               | {"name": "user1", "password": "2334444"}      | 422         | {"error": "Must be at least 8 characters long.","status": 422}                     |      |
| Register a user with password only contains lower case letters | {"name": "user1", "password": "abcdabcd"}     | 422         | {"error": "Your password does not match the security requirements.","status": 422} |      |
| Register a user with password only contains upper case letters | {"name": "user1", "password": "AAAAAAAAAA"}   | 422         | {"error": "Your password does not match the security requirements.","status": 422} |      |
| Register a user with password only contains digits             | {"name": "user1", "password": "111111111111"} | 422         | {"error": "Your password does not match the security requirements.","status": 422} |      |
| Register a user when redis is down                             | {"name": "user1", "password": "abcdABCD!233"} | 500         |                                                                                    |      |

### Login
| Description                   | Request                                       | Status code | Response                                          | Note |
|-------------------------------|-----------------------------------------------|-------------|---------------------------------------------------|------|
| Login with positive condition | {"name": "user1", "password": "abcdABCD!233"} | 200         | {"error":"User login successfully.","status":200} |      |
| Login with non-existing user  | {"name": "user2", "password": "abcdABCD!233"} | 404         | {"error":"User doesn't exist.","status":404}      |      |
| Login with wrong password     | {"name": "user2", "password": "ABCDab!233"}   | 401         | {"error":"Password is not correct.","status":401} |      |
| Login with empty password     | {"name": "user2", "password": ""}             | 401         | {"error":"Password is not correct.","status":401} |      |
| Login with empty username     | {"error":"User doesn't exist.","status":404}  | 404         | {"error":"User doesn't exist.","status":404}      |      |

## Deployment
I'll deploy this application to heroku or openshift. Currently it's still under construction.
