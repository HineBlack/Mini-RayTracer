@echo off

echo Project cleaning...
make clean
echo ...done

echo Compiling RayTracer...
make
echo ...done

set TARGET=build\Mini-RayTracer.exe
set IMAGE=build\img\image.ppm
set PS="C:\Program Files\Adobe\Adobe Photoshop CC 2015\Photoshop.exe"

echo Rendering image...
%TARGET% > %IMAGE%
echo ...done

echo Openning image file in photoshop...
%PS% %CD%\%IMAGE%
echo ...done
