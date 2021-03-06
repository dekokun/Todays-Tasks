DEVELOP_URL=http://127.0.0.1:5001/
TRAVIS_URL=http://travis-ci.org/#!/dekokun/Todays-Tasks/builds
NOW_BRANCH=`cat .git/HEAD | cut -d'/' -f3`
DEVELOP_BRANCH=development
MASTER_BRANCH=master
COV_FILE=cov.html
if ! type -P jscoverage >/dev/null
then npm install -g jscoverage
fi
if ! type -P mocha >/dev/null
then npm install -g mocha
fi
if ! type -P coffee >/dev/null
then npm install -g coffee-script
fi
if ! type -P node-dev >/dev/null
then npm install -g node-dev
fi

case $1 in
  merge)
    git push origin $DEVELOP_BRANCH || exit 1
    open $TRAVIS_URL || exit
    git checkout $MASTER_BRANCH || exit 1
    git merge $DEVELOP_BRANCH || exit 1
    open -a Firefox $DEVELOP_URL
    echo "ブランチを $DEVELOP_BRANCH に戻しますか y/n"
    read ANSWER
    if [ $ANSWER = 'y' ]; then
      git checkout $DEVELOP_BRANCH
      git branch
      echo "ブランチを $DEVELOP_BRANCH に戻しました"
    fi
    ;;
  deploy)
    git push origin $MASTER_BRANCH || exit 1
    open $TRAVIS_URL || exit
    ;;
  test)
    npm test
    open -a Firefox $DEVELOP_URL
    jscoverage model model-cov
    TEST_COV=1 mocha -R html-cov test/*.js > coverage.html && open coverage.html
    rm -rf model-cov
    ;;
  develop)
    npm update
    coffee -wc app.coffee &
    coffee -wc routes/ &
    coffee -wc model/ &
    coffee -wc public/javascript/ &
    coffee -wc test/ &
    mongo_run=`ps aux | grep '[m]ongo'`
    if [ -z "$mongo_run" ]; then
      mongod run &
    fi
    node-dev app.js
    ;;
   *)
     echo merge deploy test develop
     exit 1
esac
