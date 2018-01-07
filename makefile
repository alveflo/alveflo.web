# Starts a development server
serve:
	cd app && \
	jekyll serve --host $$IP --port $$PORT --baseurl ''

# Builds application
build:
	cd app && \
	bundle exec jekyll build --quiet
