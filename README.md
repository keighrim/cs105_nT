# 0.1

## ROUTES
**due: 10/16/2015**
We need three landing pages .
* `/`
* `/login`
* `/user/name`
Also can have arbitrary pages for internal redirections between services.
(Let's not worried about REST APIs right now.)

## UIDESIGN
**due: 10/16/2015**
Need to design these pages

1. non-logged in `/` 
    * general timeline
    * login button
1. logged in `/`
    * personal timeline
1. profile pages (`user/name`) common (shown to non-logged-in's)
    * profile
    * list of followes
    * single user timeline
1. owner's profile page
    * same as `logged-in-/`
1. visitor's profile page
    * follow button

## nT-0.1
Implement 

* `views`
* `models`
* `db`, `db/migrate`
* `config`
* `main-app.rb`