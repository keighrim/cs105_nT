# nanoTwitter [![Codeship](https://img.shields.io/codeship/0e88ea30-695a-0133-4ddd-666650db048e.svg)](https://codeship.com/projects/114521)  [![Code Climate](https://codeclimate.com/github/keighrim/cs105_nT/badges/gpa.svg)](https://codeclimate.com/github/keighrim/cs105_nT)  [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/keighrim/cs105_nT/master/LICENSE)  [![Latest tag](https://img.shields.io/github/tag/keighrim/cs105_nt.svg)](https://github.com/keighrim/cs105_nT/tags) [![Open issues](https://img.shields.io/github/issues/keighrim/cs105_nt.svg)](https://github.com/keighrim/cs105_nT/issues?utf8=%E2%9C%93&q=)

**nanoTwitter** is a toy-mimic of the popular social service [twitter](www.twitter.com), developed by [4 students](http://keighrim.github.io/cs105_nT/#/team) at Brandeis University as a course project from *Software Engineering for Scalability*.

# Contents
1. [License](#license)
1. [Website](#website)
1. [Details](#technical-details)
    - [Routings](#routings)
    - [Caching](#caching)
    - [Load Test](#load-test)
    - [REST API](#rest-api)


## License
This is a free software under [MIT license](LICENSE)

## Website
Project website is accessible here: [http://keighrim.github.io/cs105_nT/](http://keighrim.github.io/cs105_nT/)

## Technical details
----
### Routings

* **`/`**: 
    * Homepage with 50 latest tweets from all users.
    * When the user is logged in, it redirects to his/her own profile page. (`/profile/:username`)
* **`/timeline`**: 
    * Redirects to the homepage. (`/`)
* **`/explorer`**:
    * Follow suggestion page with randomly picked users and the most recent tweets.
* **`/profile`**:
    * When the user is logged in, it redirects to his/her profile page. (`profile/:username`). 
    * If not, it does to the homepage. (`/`)
* **`/profile/:username`**: 
    * By default, it will show the timeline of the target. (50 latest tweets from the target and those he/she follows)
    * It has links to tweeting history and relations of the target.
    * HIstory and relations pages can also be acceessed using `m` parameter in URL, `h` for history page, `n` for network page.

----    
### Caching

Caching was handled using a redis instance hosted on the redis cloud service. This is linked through our Heroku instance.

#### Caching strategy

##### A user's timeline:
The query to generate a users timeline (the list of tweets of all of the users that this user follows, ordered by tweet time) is the most expensive operation, so we'd focused on tackle this problem to improve scalability.
The first time that a user requests their timeline, very expensive SQL operation happens, Then this will be cached in the redis instance as a list of JSON objects representing each tweet object. 
Future requests for the timeline will then get the list of tweets, stored as JSON, from redis. 
Then we advanced to use two-tier caching, adding an outer layer to cache HTML strings, to make timeline generation even faster by reducing cost of translating JSON's and rendering HTML strings.
Outer level, HTML cache, expires very soon (in a few seconds) because we thought having users looking at outdated cached web pages for a long period is a bad idea. 
However, the deeper layer, JSON cache, stays longer (30 seconds). And only when the instance in inner layer expires, the app performs SQL call to get the most recent updates upon a user's request.
In this way we can *lazily* generate timelines on user requests, *not eagerly* on every event of creating/deleting tweets.
If one user follows or unfollows another user, the timeline is invalid, and must be rebuild. We invalidate redis caching by deleting relevant instances.

##### Home timeline(50 most recent tweets):
The home timeline, or the list of the 50 most recent tweets shown on the homepage of a non-logged in user, is stored in redis with the same two-tier strategy as individual timelines. 

----
### Load test

#### Test scenarios 
To set up load test scenarios, we provide a series of `/test` routes.

* `/test/reset/all` - Delete everything and recreate testuser
* `/test/status` - See the current state of server
* `/test/seed/_u_` - create “u” new users
* `/test/tweets/_t_` - have testuser tweet “t” times
* `/test/follow/_f_` - have f users follow testuser

Also, for batch setup we have shell scripts in `scripts` directory in the project. 

```bash
$ ./scripts/loadtest_evn.sh
usage: loadtest_env.sh <#users> <#tweets> <#followers> (optional) <base-url>
e.g.: loadtest_env.sh 100 500 30 http://localhost:4567
```

For sake of convenience, we also have three wrapping scripts for three presets from the project specification: `loadtest_evn1.sh`(100 500 30), `loadtest_evn3.sh`(500 500 100), `loadtest_evn3.sh`(3000 2000 1000).

#### Test results

##### Test case 1: u = 100, t = 500, f = 30

*  /  - user tries to simply load up the home page (non-logged in)
```
    Run 1:
    0 - 250 clients over 1 min
    1070 ms avg resp
    0.0 % err rate
    0 Timeouts

    Run 2:
    0 - 500 clients over 1min
    1690 ms avg resp
    0.2 % err rate
    0 Timouts

    Run 3:
    0 - 1000 clients over 1min
    2291 ms avg resp
    0.1 % err rate
    0 Timeouts

    Run 4:
    0 - 2000 clients over 1min
    4337 ms avg resp
    0.1 % err rate
    0 Timeouts

    Run 5:
    0 - 4000 clients over 1min
    Crashed at 00:54 with 3604 clients
    2412 ms avg resp
    71.9 % err rate
    3311 Timeouts
```

*  /user/testuser - specifically load “testusers” home page
```
    Run 1:
    0 - 1000 clients over 1 min
    6908 ms avg resp
    0.0 % err rate
    0 Timeouts
    
    Run 2:
    0 - 2000 clients over 1 min
    6970 ms avg resp
    0.0 % err rate
    0 Timeout

    Run 3:
    0 - 4000 clients over 1 min
    Crashed at 00:54 with 3604 clients
    4425 ms avg resp
    79.0 % err rate
    3485 Timeout
```

*  /user/testuser/tweet (POST) - have testuser create one tweet
```
    Run 1:
    2000 clients over 1 min
    236 ms avg resp
    0.0 % err rate
    0 Timeout 

    Run 2:
    4000 clients over 1 min
    1316 ms avg resp
    0.0 % err rate
    0 Timeout 

    Run 3:
    8000 clients over 1 min
    Crashed at 00:38
    11311 ms avg resp
    54.4 % err rate
    1972 Timeout 
```
    
----
### REST API
 as of 11/22/2015

#### GET /tweets?:tweet_id

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
#### POST /tweets?:user_id

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

#### GET /tweets/recent

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

#### GET /users?:user_id

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

#### POST /users?:name&:email

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


#### PUT /users?:id

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



#### GET /users/:user_id/tweets

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

#### GET /users/:user_id/followers

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
