# nanoTwitter
[![Codeship](https://img.shields.io/codeship/0e88ea30-695a-0133-4ddd-666650db048e.svg)](https://codeship.com/projects/114521) [![Code Climate](https://codeclimate.com/github/keighrim/cs105_nT/badges/gpa.svg)](https://codeclimate.com/github/keighrim/cs105_nT)  [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/keighrim/cs105_nT/master/LICENSE)

nanoTwitter is a toy-mimic of popular social service [twitter](www.twitter.com), developed by 4 students at Brandeis as a course project from *Software Engineering for scalability*.

## Project Page
[link](http://keighrim.github.io/cs105_nT/)


## License
This is a free software under [MIT license](LICENSE)

## Routing

TODO

## REST API
 as of 11/22/2015

### GET /tweets?:tweet_id

* Description: Returns a tweet based on its ID.
* Resource URL: https://localhost:4567/api/v1/tweets?id
* Resource Information
    * Response formats: JSON
    * Requires authentication?: No
* Parameters
    * id (*required*): The tweet id of the specific tweet to return.

##### Example Request

`GET https://localhost:4567/api/v1/tweets?id=123`

```javascript
{ 
  "id": 123, 
  "content": "foo", 
  "user_id": 456,
  "user_name": "bar",
  "created": "jan-11-2015"
}
```
### POST /tweets?:user_id

* Description: Creates a new tweet and returns it.
* Resource URL: https://localhost:4567/api/v1/tweets?user_id
* Resource Information
	* Response formats: JSON
	* Requires authentication?: No
* Parameters
	* user_id (*required*): The user id to be designated as the creator of the tweet.
	* text (*optional*): The text of the tweet. Defaults to random Faker string.

##### Example Request

`POST https://localhost:4567/api/v1/tweets?user_id=123&text=sample`

```javascript
{ 
  "id": 101, 
  "text": "sample", 
  "creator_id": 123,
  "created": "jan-11-2015"
}
```

### GET /tweets/recent

* Description: Retrieve *n* latest tweets from all users.
* Resource URL: https://localhost:4567/api/v1/tweets/recent
* Resource Information
	* Response formats: JSON
	* Requires authentication?: No
* Parameters
	* num (*optional*): Returns num recent tweets. Defaults to 10. Max of 50.

##### Example Request

`GET https://localhost:4567/api/v1/tweets/recent?num=2`

```javascript
[ 
  { 
    "id": 1, 
    "text": "foobar", 
    "creator_id": 456,
    "created": "jan-11-2015"
  },
  { 
    "id": 2, 
    "text": "foobar", 
    "creator_id": 789,
    "created": "jan-12-2015"
  }
]
```

### GET /users?:user_id

* Description: Returns information of a user based on a ID.
* Resource URL: https://localhost:4567/api/v1/users?id
* Resource Information
	* Response formats: JSON
	* Requires authentication?: No
* Parameters
	* id (*required*): The user id of the user whose information is to be returned.

##### Example Request

`GET https://localhost:4567/api/v1/users?id=123`

```javascript
{ 
  "id": 123, 
  "name": "John Doe"
}
```

### POST /users?:name&:email

* Description: Creates a new account and returns it.
* Resource URL: https://localhost:4567/api/v1/users?name
* Resource Information
	* Response formats: JSON
	* Requires authentication?: No
* Parameters
	* name (*required*): The name of the user to create.
    * email (*required*): The e-mail address of the user to create.

##### Example Request

`POST https://localhost:4567/api/v1/users?name=John+Doe`

```javascript
{ 
  "id": 101, 
  "name": "John Doe"
}
```


### PUT /users?:id

* Description: Updates user information and returns it. Changing password using this is not allowed.
* Resource URL: https://localhost:4567/api/v1/users?id
* Resource Information
	* Response formats: JSON
	* Requires authentication?: No
* Parameters
	* id (*required*): The id of the user to update.
	* name (*optional*): The new name of the user.
  * email (*optional*): The new email address of the user.

##### Example Request

`PUT https://localhost:4567/api/v1/users?id=101&name=Jane+Doe`

```javascript
{ 
  "id": 101, 
  "name": "Jane Doe"
}
```



### GET /users/:user_id/tweets

* Description: Retrieve *n* latest tweets from a specifin user.
* Resource URL: https://localhost:4567/api/v1/users/:user_id/tweets
* Resource Information
	* Response formats: JSON
	* Requires authentication?: No
* Parameters
	* user_id (*required*): The user id of the specific user whose tweets will be returned
	* num (*optional*): The number of recent tweets for this user to return. Defaults to 10. Max of 50.

##### Example Request

`GET https://localhost:4567/api/v1/users/123/tweets?num=2`

```javascript
[ 
  { 
    "id": 1, 
    "text": "foobar", 
    "creator_id": 456,
    "created": "jan-11-2015"
  },
  { 
    "id": 2, 
    "text": "foobar", 
    "creator_id": 456,
    "created": "jan-12-2015"
  }
]
```

### GET /users/:user_id/followers

* Description: Return all followers of a user.
* Resource URL: https://localhost:4567/api/v1/users/:user_id/followers
* Resource Information
	* Response formats: JSON
	* Requires authentication?: No
* Parameters
	* user_id (*required*): The user id of the specific user whose followers will be returned

##### Example Request

`GET https://localhost:4567/api/v1/users/123/followers`

```javascript
[
  { 
    "id": 124, 
    "name": "Some Person"
  },
  { 
    "id": 125, 
    "name": "Other Person"
  },
]
```
