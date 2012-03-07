case $1 in
  merge)
    git checkout master || exit 1
    git merge development || exit 1
    open -a Firefox http://127.0.0.1:5001/
    ;;
  deploy)
    git push origin master || exit 1
    open -a Firefox http://10.128.32.112:443/
    ;;
  test)
    open -a Firefox http://127.0.0.1:5001/
    ;;
  develop)
    git checkout development || exit 1
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
