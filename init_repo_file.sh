repo_name=$2
file=$1
filename=$(basename $file)
mkdir -p $repo_name
cp $file ${repo_name}/
cd $repo_name

# initialize git repo
git init

# Initial source import
git add .
git commit -m "Initial import"

# Create the “publish” branch
git checkout --orphan gh-pages
rm -rf *
git rm --cached *
git add --all .
git commit -m "clean publish branch"

# Push to remote
git checkout master
git config credential.helper store
curl -i -d "{\"name\" : \"${repo_name}\"}" https://api.github.com/user/repos -k -u luca-fiorito-11
git remote add origin https://github.com/luca-fiorito-11/${repo_name}.git
git push -u origin master
git checkout gh-pages
git push -u origin gh-pages
git checkout master

# Include travis CD/CI
git clone https://github.com/luca-fiorito-11/PVBV_utils.git
sed "s/filename_placeholder/$filename/" <PVBV_utils/travis_template.yml >.travis.yml
git add .travis.yml
git commit -m "add travis CI"
git push origin master
cd ..
