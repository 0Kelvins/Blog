@echo off
echo ******************��ʼ����******************
cp -avx public/* ../0Kelvins.github.io
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
read -p "Press any key to continue."