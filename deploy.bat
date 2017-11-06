@echo off
echo ******************开始复制******************
xcopy /s/e public ../0Kelvins.github.io /y
echo ******************复制完成******************
cd ../0Kelvins.github.io
echo ******************更新本地仓库**************
git pull origin master
echo ******************更新完成******************
echo ******************添加并提交本地仓库********
git add .
git commit -m "%date% %time%"
echo ******************推送GitHub****************
git push origin master
echo ******************完成**********************
Pause