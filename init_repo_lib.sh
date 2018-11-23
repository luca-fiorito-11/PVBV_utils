user="luca-fiorito-11"
repo="jeff-dev"
branch="master"

# Clone repository and submodules
git clone --recurse-submodules -j8 https://github.com/${user}/${repo}.git
cd ${repo}

# Switch to desired branch
git checkout ${branch}

# Update submodules
while IFS=" " read -r submodule tag remainder
do
  git submodule add https://github.com/${user}/${submodule}.git
  (cd ${submodule} && git checkout $tag)
  git add ${submodule}
done < $1
git commit -m "moved submodules to requested tags"

# Include travis CD/CI
git clone https://github.com/luca-fiorito-11/PVBV_utils.git
cp PVBV_utils/template_travis_lib.yml .travis.yml
while IFS=" " read -r submodule tag remainder
do
   echo "curl -o \${ACEDIR}/${submodule}.ace https://github.com/${user}/${submodule}/releases/download/${tag}/${submodule}.jeff33.ace -k -L"
done < $1 > get_releases.sh
git add get_releases.sh .travis.yml
git commit -m "add travis CI"

cd ..
