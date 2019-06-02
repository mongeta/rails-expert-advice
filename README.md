# README

This repository is a Rails 5.2. application, configured as a pure API. It supports users, user accounts, signups and logins via the users endpoint. Authentication is set up with Doorkeeper. Database is Postgres.

This API is specially designed to work with Ember on the front-end: requests and responses are conformed to JSON:API.

To run the application, use the following commands:

```
bundle
rake db:create db:migrate db:seed
rails s
```

# Testing

To run the tests, use the following commands:

```
bundle exec rake spec
```

# Notes

Optimal modeling would have been to use two models, one for Questions and one for Answers, as we have to do too many workarounds when we store in the same model Post and Answers, the slug must be human readable and must be unique. Also we are storing in the same model the Question and Answer, in my opinion, much easier to use two models.

I have only used one Model as Posts as the specifications, but I have used two routes and two controllers, for a better isolation (Post and Answer)

There are some things in the air, like when we should update the view count, for example.

Also the Post cannot be deleted if has answers, but if it is empty, it can be deleted.

The answers can be deleted always.

The modifications and the deletions can only be made by their creators.

In the Post and Answer controllers, in the :index, I have used the filter params as the JSON:API, even we are only using one filter for _tags_ in Post, and one filter for _answers_ in Answers. I have created two scopes with lambda for those two cases.

The user is not shown in each publication / answer because we only have his email, when we have his alias informed, maybe we can add it to the publications / answers.
