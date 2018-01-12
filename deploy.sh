#! /bin/bash # 直接bash deploy.sh

echo ------------------提交Blog------------------

read -p "是否更新Blog(y/n) :" updateOp1
if [ "$updateOp1"x = "y"x ]; then
	echo ******************更新本地仓库**************
	git pull origin master
	echo ******************更新完成******************
else
	echo ******************跳过更新******************
fi

echo ******************添加并提交本地仓库********
git add .
git commit -m "$(date "+%Y-%m-%d %H:%M:%S")"
echo ******************推送GitHub****************
git push origin master
echo ******************完成**********************

echo ------------------提交0Kelvins.github.io----
cd ../0Kelvins.github.io

read -p "是否更新github pages(y/n) :" updateOp1
if [ "$updateOp1"x = "y"x ]; then
	echo ******************更新本地仓库**************
	git pull origin master
	echo ******************更新完成******************
else
	echo ******************跳过更新******************
fi

echo ******************开始复制******************
cp -avxu ../Blog/public/* .
echo ******************复制完成******************

cd ../0Kelvins.github.io
echo ******************添加并提交本地仓库********
git add .
git commit -m "$(date "+%Y-%m-%d %H:%M:%S")"
echo ******************推送GitHub****************
git push origin master
echo ******************完成**********************

cd ../Blog
read -p "Press any key to continue."