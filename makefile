CC		= g++
SRC		= src

TARGET	= build\Mini-RayTracer.exe

.PHONY: all clean

all:
	$(CC) $(SRC)\main.cc -o $(TARGET)

clean:
	@del $(TARGET)
