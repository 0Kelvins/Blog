@echo off

echo ******************�ύBlog******************
echo ******************��Ӳ��ύ���زֿ�********
git add .
git commit -m "%date% %time%"
echo ******************����GitHub****************
git push origin master
echo ******************���**********************

echo ******************�ύ0Kelvins.github.io****
cd ../0Kelvins.github.io
echo ******************���±��زֿ�**************
git pull origin master
echo ******************�������******************

cd ../Blog
echo ******************��ʼ����******************
xcopy /s/e public ../0Kelvins.github.io /y
echo ******************�������******************

cd ../0Kelvins.github.io
echo ******************��Ӳ��ύ���زֿ�********
git add .
git commit -m "%date% %time%"
echo ******************����GitHub****************
git push origin master
echo ******************���**********************
Pause