file=$1
repo_name=$2
filename=$(basename $file)
user="luca-fiorito-11"
tag="v4.0T0"
token=$(cat ~/.github_token)
mkdir -p $repo_name
cp $file ${repo_name}/
cd $repo_name

# initialize git repo
git init

# Initial source import
git add .
git commit -m "Initial import"

# Create the 'publish' branch
git checkout --orphan gh-pages
rm -rf *
git rm --cached *
touch .keep
git add --all .
git commit -m "clean publish branch"

# Push to remote
git checkout master
git config credential.helper store
curl -i -d "{\"name\" : \"${repo_name}\"}" https://api.github.com/user/repos -k -u ${user}:${token}
git remote add origin https://github.com/${user}/${repo_name}.git
git push -u origin master
git checkout gh-pages
git push -u origin gh-pages
git checkout master

# Include travis CD/CI
git clone https://github.com/luca-fiorito-11/PVBV_utils.git
sed "s/filename_placeholder/$filename/" <PVBV_utils/travis_eval_template.yml >.travis.yml
git add .travis.yml
git commit -m "add travis CI"
git push origin master

# Enable travis-CI with TRVAIS-CI Client API (must be logged in)
travis enable --org -I -r ${user}/${repo_name}
travis env set GITHUB_TOKEN $token --private -I -r ${user}/${repo_name}

# Tag reference release
git tag ${tag}
git push origin ${tag}
cd ..
