@echo off
echo ******************��ʼ����******************
xcopy /s/e public ../0Kelvins.github.io /y
echo ******************�������******************
cd ../0Kelvins.github.io
echo ******************���±��زֿ�**************
git pull origin master
echo ******************�������******************
echo ******************��Ӳ��ύ���زֿ�********
git add .
git commit -m "%date% %time%"
echo ******************����GitHub****************
git push origin master
echo ******************���**********************
Pause