# README


# Prerequisites:
- Docker
- Postgres

# How to run:
- Clone the repository
- Run `docker-compose up` in the root directory
- Run `docker-compose exec web rails db:migrate` to run the migrations
- Run `docker-compose exec web rails db:seed` to run the seed script

# API Endpoints:
- GET /posts/index_with_last_two_comments?page=:page
- GET /posts/:id
- POST /posts
  - **post[caption]**: string, 
  - **post[account_id]**: integer, 
  - **post[image]**: file
- POST /accounts/:account_id/posts/:post_id/comments
  - **comment[content]**: string

For easier testing of the upload functionality, I have added a frontend app https://github.com/grigoryan/rn-frontend that runs on 3001 port on localhost 