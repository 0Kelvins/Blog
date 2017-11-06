echo ******************提交Blog******************
echo ******************添加并提交本地仓库********
git add .
git commit -m "$(date "+%Y-%m-%d %H:%M:%S")"
echo ******************推送GitHub****************
git push origin master
echo ******************完成**********************

echo ******************提交0Kelvins.github.io****
cd ../0Kelvins.github.io
echo ******************更新本地仓库**************
git pull origin master
echo ******************更新完成******************

cd ../Blog
echo ******************开始复制******************
cp -avx public/* ../0Kelvins.github.io
echo ******************复制完成******************

cd ../0Kelvins.github.io
echo ******************添加并提交本地仓库********
git add .
git commit -m "$(date "+%Y-%m-%d %H:%M:%S")"
echo ******************推送GitHub****************
git push origin master
echo ******************完成**********************

read -p "Press any key to continue."