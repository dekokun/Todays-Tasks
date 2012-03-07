DEVELOP_URL=http://127.0.0.1:5001/
PRODUCT_URL=http://10.128.32.112:443/
NOW_BRANCH=`cat .git/HEAD | cut -d'/' -f3`
DEVELOP_BRANCH=development
MASTER_BRANCH=master

case $1 in
  merge)
    git checkout $MASTER_BRANCH || exit 1
    git merge $DEVELOP_BRANCH || exit 1
    open -a Firefox $DEVELOP_URL
    ;;
  deploy)
    git push origin $MASTER_BRANCH || exit 1
    open -a Firefox $PRODUCT_URL
    ;;
  test)
    open -a Firefox $DEVELOP_URL
    ;;
  develop)
    git checkout $DEVELOP_BRANCH || exit 1
    coffee -wc app.coffee &
    coffee -wc routes/ &
    coffee -wc public/javascript/ &
    mongod run --config /usr/local/Cellar/mongodb/2.0.3-x86_64/mongod.conf &
    node-dev app.js
    ;;
   *)
     echo merge deploy test develop
     exit 1
esac
