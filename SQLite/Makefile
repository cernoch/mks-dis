# Autodetect file extension
ifeq ($(OS),Windows_NT)
all: sqlite3.exe extension-functions.dll
else
all: sqlite3 extension-functions.so
endif

# Linux binaries
sqlite3: shell.o sqlite3.o
	gcc -fPIC -o $@ $^ -pthread -ldl
extension-functions.so: extension-functions.c sqlite3
	gcc -fPIC -o $@ $< -shared -fPIC -lm

# MINGW binary
sqlite3.exe: shell.c sqlite3.c
	gcc -o $@ $^ -lpthread -ldl
extension-functions.dll: extension-functions.c sqlite3
	gcc -shared -o $@ $< -lm

# Shared rules
%.o: %.c
	gcc -fPIC -c -o $@ $<

clean:
	rm -f sqlite3 sqlite3.exe extension-functions.so extension-functions.dll 
