# Starts a development server
serve:
	cd app && \
	jekyll serve --host $$IP --port $$PORT --baseurl ''

install:
	cd app && gem install jekyll bundle 

# Builds application
build:
	cd app && \
	bundle exec jekyll build --quiet #&& \
	#bundle exec htmlproofer ./_site

# Travis CI install
build-ci: install build 
