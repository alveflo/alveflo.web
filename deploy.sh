make build

git config --global user.email "victor.alveflo@gmail.com"
git config --global user.name "Travis CI"

cd app
rm -rf .git

cd _site
git init
git add --all
git commit -m "Travis CI deploy (Build $TRAVIS_BUILD_NUMBER)"
git push --force https://${TOKEN}@github.com/alveflo/alveflo.github.io.git