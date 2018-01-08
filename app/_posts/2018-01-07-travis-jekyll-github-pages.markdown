---
layout: post
title:  Deploying your Jekyll site to GitHub Pages using Travis CI
categories: code
---

This article will describe how you can set up a continuous
deployment for your [Jekyll](https://jekyllrb.com) 
site using [Travis](https://travis-ci.org) as CI and 
[Github Pages](https://pages.github.com) as your static file host.

[Jekyll](https://jekyllrb.com) is a "blog-aware" static website generator written in
Ruby with tons of open source themes and plugins, which makes it easy
to create a simple website or blog in no time. 
[Travis CI](https://travis-ci.org) offers a free plan for open source projects and 
[Github](https://pages.github.com) offers free hosting for static files, 
one website per user and per project, known as Github Pages.

## Setting up deployment
When deploying, we're doing this in two steps
- Build the jekyll site
- Push the output to a github repository

I've chosen to use two separate repositories, one for the source code
(i.e. Jekyll code) and one for the output (i.e. output html files).
The output repository will be your Github pages repo (`user.github.io`).

#### Build
I like to use makefiles for these types of things, however if you're
a Windows user you're out of luck since `make` is not available
(at least not out of the box). So if make is not an option for you,
you can copy the code below and use in a bash script or whatever.

First, let's create a makefile.
```bash
$ touch makefile
``` 

Then we're adding three tasks: `serve`, `install`, `build` and `build-ci`.
```makefile
# Starts a development server
serve:
	jekyll serve --host $$IP --port $$PORT --baseurl ''

install:
	gem install jekyll bundle
	bundle install

# Builds application
build:
	bundle exec jekyll build --quiet 

# Travis CI build
build-ci: install build 
```

#### Deploy script 

Let's create a shell script for this
```
$ touch deploy.sh
```

What we need to do now is to do some git configuration
and navigate into our `_site` directory (where the site is built)
and push the content to our github pages repo. Note that you need to
generate a [Github access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) 
in order to be able to push to your repo from Travis.

```
git config --global user.email "your@email.com"
git config --global user.name "Travis CI"

cd _site
git init
git add --all
git commit -m "Travis CI deploy (Build $TRAVIS_BUILD_NUMBER)"
git push --force https://${TOKEN}@github.com/<REPO> master
```

#### Travis config
To wire it up, we're creating a `.travis.yml` file, which
is the config file for Travis.

```bash
$ touch .travis.yml
```

And then we're telling Travis to run `make build-ci` to install the
application and then run our deploy script afterwards.
```yaml
language: ruby
rvm:
- 2.3.3

install:
- make build-ci

script:
- sh deploy.sh
```

That's it!
