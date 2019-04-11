default: cuda

cuda : src/main.cu src/util.c
	nvcc -o bin/main src/main.cu src/util.c

serial : src/serial.c src/util.c
	gcc -o bin/main src/serial.c src/util.c