# Starts a development server
serve:
	cd app && \
	jekyll serve --host $$IP --port $$PORT --baseurl ''

install:
	cd app && \
	gem install jekyll bundle && \
	bundle install

# Builds application
build:
	cd app && \
	bundle exec jekyll build --quiet 

# Travis CI build
build-ci: install build 
