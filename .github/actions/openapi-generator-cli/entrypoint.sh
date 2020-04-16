#!/bin/sh
set -eu

git config --global user.name github-actions
git config --global user.email noreply@github.com

export GIT_BRANCH="$(git symbolic-ref HEAD --short 2>/dev/null)"
if [ "$GIT_BRANCH" = "" ] ; then
  GIT_BRANCH="$(git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }')";
  export GIT_BRANCH=${GIT_BRANCH#remotes/origin/};
fi
git remote set-url origin https://taroshun32:${GITHUB_TOKEN}@github.com/taroshun32/openapi-generator.git
git checkout $GIT_BRANCH

./mvnw clean package -DskipTests=true

rm -f code-gen/openapi-generator-cli.jar
cp -f modules/openapi-generator-cli/target/openapi-generator-cli.jar code-gen/

# ignore no diff
set +e

git add .
git commit -m "add generated jar"
git push origin $GIT_BRANCH

echo 'finish generated jar'