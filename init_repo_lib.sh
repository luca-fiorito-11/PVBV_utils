list=$1
user="luca-fiorito-11"
repo="jeff-dev"
branch="master"

set -e

# Clone repository and submodules
git clone --recurse-submodules -j8 https://github.com/${user}/${repo}.git
cd ${repo}

# Switch to desired branch
[[ ${branch} != "master" ]] && git checkout -b ${branch}

# Update submodules
while IFS=" " read -r submodule tag remainder
do
  git submodule status | awk '{ print $2 }' | grep -q ${submodule} || git submodule add https://github.com/${user}/${submodule}
  (cd ${submodule} && git checkout ${tag})
  git add ${submodule}
done < ${list}
git commit -m "moved submodules to requested tags"

# Include travis CD/CI
git clone https://github.com/luca-fiorito-11/PVBV_utils.git
cp PVBV_utils/travis_lib_template.yml .travis.yml
while IFS=" " read -r submodule tag remainder
do
   echo "curl -o \${ACEDIR}/${submodule}.ace https://github.com/${user}/${submodule}/releases/download/${tag}/${submodule}.jeff33.ace -k -L"
done < ${list} > get_releases.sh
git add get_releases.sh .travis.yml
git commit -m "add travis CI"

cd ..
