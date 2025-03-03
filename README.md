# ![React + Redux Example App](project-logo.png)

[![RealWorld Frontend](https://img.shields.io/badge/realworld-frontend-%23783578.svg)](http://realworld.io)

> ### React + Redux codebase containing real world examples (CRUD, auth, advanced patterns, etc) that adheres to the [RealWorld](https://github.com/gothinkster/realworld-example-apps) spec and API.

<a href="https://stackblitz.com/edit/react-redux-realworld" target="_blank"><img width="187" src="https://github.com/gothinkster/realworld/blob/master/media/edit_on_blitz.png?raw=true" /></a>&nbsp;&nbsp;<a href="https://thinkster.io/tutorials/build-a-real-world-react-redux-application" target="_blank"><img width="384" src="https://raw.githubusercontent.com/gothinkster/realworld/master/media/learn-btn-hr.png" /></a>

### [Demo](https://react-redux.realworld.io)&nbsp;&nbsp;&nbsp;&nbsp;[RealWorld](https://github.com/gothinkster/realworld)

Originally created for this [GH issue](https://github.com/reactjs/redux/issues/1353). The codebase is now feature complete; please submit bug fixes via pull requests & feedback via issues.

We also have notes in [**our wiki**](https://github.com/gothinkster/react-redux-realworld-example-app/wiki) about how the various patterns used in this codebase and how they work (thanks [@thejmazz](https://github.com/thejmazz)!)


## Getting started

You can view a live demo over at https://react-redux.realworld.io/

To get the frontend running locally:

- Clone this repo
- `npm install` to install all req'd dependencies
- `npm start` to start the local server (this project uses create-react-app)

Local web server will use port 4100 instead of standard React's port 3000 to prevent conflicts with some backends like Node or Rails. You can configure port in scripts section of `package.json`: we use [cross-env](https://github.com/kentcdodds/cross-env) to set environment variable PORT for React scripts, this is Windows-compatible way of setting environment variables.

Alternatively, you can add `.env` file in the root folder of project to set environment variables (use PORT to change webserver's port). This file will be ignored by git, so it is suitable for API keys and other sensitive stuff. Refer to [dotenv](https://github.com/motdotla/dotenv) and [React](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#adding-development-environment-variables-in-env) documentation for more details. Also, please remove setting variable via script section of `package.json` - `dotenv` never override variables if they are already set.  

### Making requests to the backend API

For convenience, we have a live API server running at https://conduit.productionready.io/api for the application to make requests against. You can view [the API spec here](https://github.com/GoThinkster/productionready/blob/master/api) which contains all routes & responses for the server.

The source code for the backend server (available for Node, Rails and Django) can be found in the [main RealWorld repo](https://github.com/gothinkster/realworld).

If you want to change the API URL to a local server, simply edit `src/agent.js` and change `API_ROOT` to the local server's URL (i.e. `http://localhost:3000/api`)


## Functionality overview

The example application is a social blogging site (i.e. a Medium.com clone) called "Conduit". It uses a custom API for all requests, including authentication. You can view a live demo over at https://redux.productionready.io/

**General functionality:**

- Authenticate users via JWT (login/signup pages + logout button on settings page)
- CRU* users (sign up & settings page - no deleting required)
- CRUD Articles
- CR*D Comments on articles (no updating required)
- GET and display paginated lists of articles
- Favorite articles
- Follow other users

**The general page breakdown looks like this:**

- Home page (URL: /#/ )
    - List of tags
    - List of articles pulled from either Feed, Global, or by Tag
    - Pagination for list of articles
- Sign in/Sign up pages (URL: /#/login, /#/register )
    - Use JWT (store the token in localStorage)
- Settings page (URL: /#/settings )
- Editor page to create/edit articles (URL: /#/editor, /#/editor/article-slug-here )
- Article page (URL: /#/article/article-slug-here )
    - Delete article button (only shown to article's author)
    - Render markdown from server client side
    - Comments section at bottom of page
    - Delete comment button (only shown to comment's author)
- Profile page (URL: /#/@username, /#/@username/favorites )
    - Show basic user info
    - List of articles populated from author's created articles or author's favorited articles

## Setup build and deploy infrastructure

For creating build and deploy pipeline Jenkins CI/CD tools is used.
Files used to define the pipeline and execute build and deploy are:
- Jenkinsfile (for building and deploying app artifacts to AWS S3 buckets)
- Jenkinsfile-production (for deploying production app to AWS S3 bucket)
- build.bash (builds app for staging and production environment)

**Testing build and deploy pipeline locally**

In order to test build pipeline on a local machine create build infrastructure
by running following code:<br/>
```
cd ./infrastructure/build/
docker-compose build
docker-compose up -d
```
Jenkins node for building NodeJS has to be created manually.
There is SSH private key file remote_key which can be used for authentication
to the node from Jenkins master server.
There are 3 mandatory string parameters that has to be defined when creating
the Jenkins build pipeline:
  - ARTIFACT_NAME - the name of created artifact file containing staging and production build directory
  - ARTIFACTS_S3_BUCKET - the name of the S3 bucket where app artifacts are uploaded
  - APP_S3_BUCKET - the name of the S3 bucket where production app is hosted

**Creating AWS infrastructure**

The required AWS infrastructure (CloudFlare distribution and S3 buckets) can be created with Terraform by running following commands:<br/>
```
cd ./infrastructure/aws
terraform apply
```
**Building Nginx Docker image with staging and production app**

There are two files, aws_config and aws_credentials, that are used in the Dockerfile but not created in the repo. Structure of these files is identical to the files
created by the **"aws configure"** command.
These files has to be created either manually or using the **"aws configure"** command
prior running the Docker image build command.
```
NOTE:
Because the Nginx configuration does not support HTTPS connections yet, the Docker image should be used in test environment not in production.
```
To build Nginx image run:
```
docker build -t nginx:multistage --build-arg artifact_name=ARTIFACT_FILE_NAME_IN_S3_BUCKET --build-arg aws_bucket_name=NAME_OF_S3_BUCKET_CONTAINING_THE_ARTIFACT .
```
To create and run Nginx container execute following command:
```
docker run -d -e "RUN_ENV=$ENVIRONMENT" -p 80:80 --name mynginx nginx:multistage
```
```
NOTE:
The $ENVIRONMENT variable should have either staging or production value.
```

<br />

[![Brought to you by Thinkster](https://raw.githubusercontent.com/gothinkster/realworld/master/media/end.png)](https://thinkster.io)
