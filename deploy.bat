@echo off

echo ------------------�ύBlog-----------------

echo ******************���±��زֿ�**************
set /p updateOp1 = "�Ƿ���£�y/n����"
if "%updateOp%" == "y" (
git pull origin master
echo ******************�������******************
)

echo ******************��Ӳ��ύ���زֿ�********
git add .
git commit -m "%date% %time%"

echo ******************����GitHub****************
git push origin master
echo ******************�������******************

echo ------------------�ύ0Kelvins.github.io---

cd ../0Kelvins.github.io
echo ******************���±��زֿ�**************
set /p updateOp2 = "�Ƿ���£�y/n����"
if "%updateOp%" == "y" (
git pull origin master
echo ******************�������******************
)

echo ******************��ʼ����******************
xcopy /s/e ..\Blog\public . /y
echo ******************�������******************

cd ../0Kelvins.github.io
echo ******************��Ӳ��ύ���زֿ�*********
git add .
git commit -m "%date% %time%"

echo ******************����GitHub****************
git push origin master
echo ******************���**********************

cd ../Blog

Pause