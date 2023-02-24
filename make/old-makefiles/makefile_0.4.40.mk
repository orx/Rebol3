# REBOL Makefile -- Generated by make-make.reb (do not edit) on 10-Feb-2021/0:17:41+1:00
# This makefile is intentional kept simple to make builds possible on
# a wider range of target platforms.

# To regenerate this file:
#    make make

# To generate this file for a different platform, check systems.reb file
# and provide an OS_ID (from the systems table). Linux 2.5 for example:
#    make make OS_ID=0.4.3

# To cross compile using a different toolchain and include files:
#    $TOOLS - should point to bin where gcc is found
#    $INCL  - should point to the dir for includes
# Example make:
#    make TOOLS=~/amiga/amiga/bin/ppc-amigaos- INCL=/SDK/newlib/include

# For the build toolchain:
CC=	$(TOOLS)gcc
NM=	$(TOOLS)nm
STRIP=	$(TOOLS)strip

# CP allows different copy progs:
CP= cp
# LS allows different ls progs:
LS= ls -l
# RM allows different RM progs:
RM= @-rm -rf
# UP - some systems do not use ../
UP= ..
# CD - some systems do not use ./
CD= ./
# Special tools:
T= $(UP)/src/tools
# Paths used by make:
S= ../src
R= $S/core

INCL ?= .
I= -I$(INCL) -I$S/include/

TO_OS?= TO_LINUX
OS_ID?= 0.4.40
BIN_SUFFIX=
LIB_SUFFIX= .so
RES=
RAPI_FLAGS=  -O2 -fvisibility=hidden -D__LP64__ -fPIC -DENDIAN_LITTLE
HOST_FLAGS=	-DREB_EXE  -O2 -fvisibility=hidden -D__LP64__ -DENDIAN_LITTLE -D_FILE_OFFSET_BITS=64
RLIB_FLAGS=
USE_FLAGS=

# Flags for core and for host:
RFLAGS= -c -D$(TO_OS) -DREB_API  $(RAPI_FLAGS) $(USE_FLAGS) $I
HFLAGS= -c -D$(TO_OS) $(HOST_FLAGS) $(USE_FLAGS) $I
CLIB=  -ldl -lm

### Build targets:
top:
	$(MAKE) r3$(BIN_SUFFIX)

clean:
	$(RM) $(RES)
	#(RM) objs/mbedtls/*.o
	$(RM) objs/*.o

all:
	$(MAKE) r3$(BIN_SUFFIX)

prep:
	$(RM) objs/b-init.* # boot init must be always recompiled


### Post build actions

purge:
	$(RM) libr3.*
	$(RM) host$(BIN_SUFFIX)
	$(MAKE) lib
	$(MAKE) host$(BIN_SUFFIX)

check:
	$(STRIP) -s -o r3.s r3$(BIN_SUFFIX)
	$(STRIP) -x -o r3.x r3$(BIN_SUFFIX)
	$(STRIP) -X -o r3.X r3$(BIN_SUFFIX)
	$(LS) r3*

strip:
	$(STRIP) r3$(BIN_SUFFIX)
	
OBJS =	objs/a-constants.o objs/a-globals.o objs/a-lib.o objs/b-boot.o \
	objs/b-init.o objs/c-do.o objs/c-error.o objs/c-frame.o \
	objs/c-function.o objs/c-handle.o objs/c-port.o objs/c-task.o \
	objs/c-word.o objs/d-crash.o objs/d-dump.o objs/d-print.o \
	objs/f-blocks.o objs/f-deci.o objs/f-dtoa.o objs/f-enbase.o \
	objs/f-extension.o objs/f-int.o objs/f-math.o objs/f-modify.o \
	objs/f-qsort.o objs/f-random.o objs/f-round.o objs/f-series.o \
	objs/f-stubs.o objs/l-scan.o objs/l-types.o objs/m-gc.o \
	objs/m-pools.o objs/m-series.o objs/n-control.o objs/n-crypt.o \
	objs/n-data.o objs/n-image.o objs/n-io.o objs/n-loop.o \
	objs/n-math.o objs/n-sets.o objs/n-strings.o objs/n-system.o \
	objs/p-checksum.o objs/p-clipboard.o objs/p-console.o objs/p-dir.o \
	objs/p-dns.o objs/p-event.o objs/p-file.o objs/p-net.o \
	objs/p-midi.o objs/s-cases.o objs/s-crc.o objs/s-file.o \
	objs/s-find.o objs/s-make.o objs/s-mold.o objs/s-ops.o \
	objs/s-trim.o objs/s-unicode.o objs/t-bitset.o objs/t-block.o \
	objs/t-char.o objs/t-datatype.o objs/t-date.o objs/t-decimal.o \
	objs/t-event.o objs/t-function.o objs/t-gob.o objs/t-image.o \
	objs/t-integer.o objs/t-logic.o objs/t-map.o objs/t-money.o \
	objs/t-none.o objs/t-object.o objs/t-pair.o objs/t-port.o \
	objs/t-string.o objs/t-time.o objs/t-tuple.o objs/t-typeset.o \
	objs/t-utype.o objs/t-vector.o objs/t-word.o objs/u-aes.o \
	objs/u-bigint.o objs/u-bincode.o objs/u-bmp.o objs/u-chacha20.o \
	objs/u-compress.o objs/u-dh.o objs/u-dialect.o objs/u-gif.o \
	objs/u-iconv.o objs/u-image-resize.o objs/u-jpg.o objs/u-lzma.o \
	objs/u-parse.o objs/u-png.o objs/u-poly1305.o objs/u-rc4.o \
	objs/u-rsa.o objs/u-uECC.o objs/u-zlib.o objs/u-wav.o \
	objs/u-mbedtls.o objs/mbedtls/platform.o objs/mbedtls/platform_util.o objs/mbedtls/md4.o \
	objs/mbedtls/md5.o objs/mbedtls/ripemd160.o objs/mbedtls/sha1.o objs/mbedtls/sha256.o \
	objs/mbedtls/sha512.o 

HOST =	objs/host-main.o objs/host-args.o objs/host-device.o objs/host-stdio.o \
	objs/dev-net.o objs/dev-dns.o objs/host-ext-test.o objs/host-lib.o \
	objs/host-readline.o objs/dev-stdio.o objs/dev-event.o objs/dev-file.o \
	objs/dev-midi-osx.o 


# Directly linked r3 executable:
r3$(BIN_SUFFIX):	objs $(OBJS) $(HOST) $(RES)
	$(CC) -o r3$(BIN_SUFFIX) $(OBJS) $(HOST) $(RES) $(CLIB)
#	-$(NM) -a r3$(BIN_SUFFIX)

objs:
	mkdir -p objs
	mkdir -p objs/mbedtls

### File build targets:
b-boot.c: $(SRC)/boot/boot.reb
	$(REBOL) -sqw $(SRC)/tools/make-boot.reb

objs/a-constants.o:   $R/a-constants.c
	$(CC) $R/a-constants.c $(RFLAGS) -o objs/a-constants.o

objs/a-globals.o:     $R/a-globals.c
	$(CC) $R/a-globals.c $(RFLAGS) -o objs/a-globals.o

objs/a-lib.o:         $R/a-lib.c
	$(CC) $R/a-lib.c $(RFLAGS) -o objs/a-lib.o

objs/b-boot.o:        $R/b-boot.c
	$(CC) $R/b-boot.c $(RFLAGS) -o objs/b-boot.o

objs/b-init.o:        $R/b-init.c
	$(CC) $R/b-init.c $(RFLAGS) -o objs/b-init.o

objs/c-do.o:          $R/c-do.c
	$(CC) $R/c-do.c $(RFLAGS) -o objs/c-do.o

objs/c-error.o:       $R/c-error.c
	$(CC) $R/c-error.c $(RFLAGS) -o objs/c-error.o

objs/c-frame.o:       $R/c-frame.c
	$(CC) $R/c-frame.c $(RFLAGS) -o objs/c-frame.o

objs/c-function.o:    $R/c-function.c
	$(CC) $R/c-function.c $(RFLAGS) -o objs/c-function.o

objs/c-handle.o:      $R/c-handle.c
	$(CC) $R/c-handle.c $(RFLAGS) -o objs/c-handle.o

objs/c-port.o:        $R/c-port.c
	$(CC) $R/c-port.c $(RFLAGS) -o objs/c-port.o

objs/c-task.o:        $R/c-task.c
	$(CC) $R/c-task.c $(RFLAGS) -o objs/c-task.o

objs/c-word.o:        $R/c-word.c
	$(CC) $R/c-word.c $(RFLAGS) -o objs/c-word.o

objs/d-crash.o:       $R/d-crash.c
	$(CC) $R/d-crash.c $(RFLAGS) -o objs/d-crash.o

objs/d-dump.o:        $R/d-dump.c
	$(CC) $R/d-dump.c $(RFLAGS) -o objs/d-dump.o

objs/d-print.o:       $R/d-print.c
	$(CC) $R/d-print.c $(RFLAGS) -o objs/d-print.o

objs/f-blocks.o:      $R/f-blocks.c
	$(CC) $R/f-blocks.c $(RFLAGS) -o objs/f-blocks.o

objs/f-deci.o:        $R/f-deci.c
	$(CC) $R/f-deci.c $(RFLAGS) -o objs/f-deci.o

objs/f-dtoa.o:        $R/f-dtoa.c
	$(CC) $R/f-dtoa.c $(RFLAGS) -o objs/f-dtoa.o

objs/f-enbase.o:      $R/f-enbase.c
	$(CC) $R/f-enbase.c $(RFLAGS) -o objs/f-enbase.o

objs/f-extension.o:   $R/f-extension.c
	$(CC) $R/f-extension.c $(RFLAGS) -o objs/f-extension.o

objs/f-int.o:         $R/f-int.c
	$(CC) $R/f-int.c $(RFLAGS) -o objs/f-int.o

objs/f-math.o:        $R/f-math.c
	$(CC) $R/f-math.c $(RFLAGS) -o objs/f-math.o

objs/f-modify.o:      $R/f-modify.c
	$(CC) $R/f-modify.c $(RFLAGS) -o objs/f-modify.o

objs/f-qsort.o:       $R/f-qsort.c
	$(CC) $R/f-qsort.c $(RFLAGS) -o objs/f-qsort.o

objs/f-random.o:      $R/f-random.c
	$(CC) $R/f-random.c $(RFLAGS) -o objs/f-random.o

objs/f-round.o:       $R/f-round.c
	$(CC) $R/f-round.c $(RFLAGS) -o objs/f-round.o

objs/f-series.o:      $R/f-series.c
	$(CC) $R/f-series.c $(RFLAGS) -o objs/f-series.o

objs/f-stubs.o:       $R/f-stubs.c
	$(CC) $R/f-stubs.c $(RFLAGS) -o objs/f-stubs.o

objs/l-scan.o:        $R/l-scan.c
	$(CC) $R/l-scan.c $(RFLAGS) -o objs/l-scan.o

objs/l-types.o:       $R/l-types.c
	$(CC) $R/l-types.c $(RFLAGS) -o objs/l-types.o

objs/m-gc.o:          $R/m-gc.c
	$(CC) $R/m-gc.c $(RFLAGS) -o objs/m-gc.o

objs/m-pools.o:       $R/m-pools.c
	$(CC) $R/m-pools.c $(RFLAGS) -o objs/m-pools.o

objs/m-series.o:      $R/m-series.c
	$(CC) $R/m-series.c $(RFLAGS) -o objs/m-series.o

objs/n-control.o:     $R/n-control.c
	$(CC) $R/n-control.c $(RFLAGS) -o objs/n-control.o

objs/n-crypt.o:       $R/n-crypt.c
	$(CC) $R/n-crypt.c $(RFLAGS) -o objs/n-crypt.o

objs/n-data.o:        $R/n-data.c
	$(CC) $R/n-data.c $(RFLAGS) -o objs/n-data.o

objs/n-image.o:       $R/n-image.c
	$(CC) $R/n-image.c $(RFLAGS) -o objs/n-image.o

objs/n-io.o:          $R/n-io.c
	$(CC) $R/n-io.c $(RFLAGS) -o objs/n-io.o

objs/n-loop.o:        $R/n-loop.c
	$(CC) $R/n-loop.c $(RFLAGS) -o objs/n-loop.o

objs/n-math.o:        $R/n-math.c
	$(CC) $R/n-math.c $(RFLAGS) -o objs/n-math.o

objs/n-sets.o:        $R/n-sets.c
	$(CC) $R/n-sets.c $(RFLAGS) -o objs/n-sets.o

objs/n-strings.o:     $R/n-strings.c
	$(CC) $R/n-strings.c $(RFLAGS) -o objs/n-strings.o

objs/n-system.o:      $R/n-system.c
	$(CC) $R/n-system.c $(RFLAGS) -o objs/n-system.o

objs/p-checksum.o:    $R/p-checksum.c
	$(CC) $R/p-checksum.c $(RFLAGS) -o objs/p-checksum.o

objs/p-clipboard.o:   $R/p-clipboard.c
	$(CC) $R/p-clipboard.c $(RFLAGS) -o objs/p-clipboard.o

objs/p-console.o:     $R/p-console.c
	$(CC) $R/p-console.c $(RFLAGS) -o objs/p-console.o

objs/p-dir.o:         $R/p-dir.c
	$(CC) $R/p-dir.c $(RFLAGS) -o objs/p-dir.o

objs/p-dns.o:         $R/p-dns.c
	$(CC) $R/p-dns.c $(RFLAGS) -o objs/p-dns.o

objs/p-event.o:       $R/p-event.c
	$(CC) $R/p-event.c $(RFLAGS) -o objs/p-event.o

objs/p-file.o:        $R/p-file.c
	$(CC) $R/p-file.c $(RFLAGS) -o objs/p-file.o

objs/p-net.o:         $R/p-net.c
	$(CC) $R/p-net.c $(RFLAGS) -o objs/p-net.o

objs/p-midi.o:        $R/p-midi.c
	$(CC) $R/p-midi.c $(RFLAGS) -o objs/p-midi.o

objs/s-cases.o:       $R/s-cases.c
	$(CC) $R/s-cases.c $(RFLAGS) -o objs/s-cases.o

objs/s-crc.o:         $R/s-crc.c
	$(CC) $R/s-crc.c $(RFLAGS) -o objs/s-crc.o

objs/s-file.o:        $R/s-file.c
	$(CC) $R/s-file.c $(RFLAGS) -o objs/s-file.o

objs/s-find.o:        $R/s-find.c
	$(CC) $R/s-find.c $(RFLAGS) -o objs/s-find.o

objs/s-make.o:        $R/s-make.c
	$(CC) $R/s-make.c $(RFLAGS) -o objs/s-make.o

objs/s-mold.o:        $R/s-mold.c
	$(CC) $R/s-mold.c $(RFLAGS) -o objs/s-mold.o

objs/s-ops.o:         $R/s-ops.c
	$(CC) $R/s-ops.c $(RFLAGS) -o objs/s-ops.o

objs/s-trim.o:        $R/s-trim.c
	$(CC) $R/s-trim.c $(RFLAGS) -o objs/s-trim.o

objs/s-unicode.o:     $R/s-unicode.c
	$(CC) $R/s-unicode.c $(RFLAGS) -o objs/s-unicode.o

objs/t-bitset.o:      $R/t-bitset.c
	$(CC) $R/t-bitset.c $(RFLAGS) -o objs/t-bitset.o

objs/t-block.o:       $R/t-block.c
	$(CC) $R/t-block.c $(RFLAGS) -o objs/t-block.o

objs/t-char.o:        $R/t-char.c
	$(CC) $R/t-char.c $(RFLAGS) -o objs/t-char.o

objs/t-datatype.o:    $R/t-datatype.c
	$(CC) $R/t-datatype.c $(RFLAGS) -o objs/t-datatype.o

objs/t-date.o:        $R/t-date.c
	$(CC) $R/t-date.c $(RFLAGS) -o objs/t-date.o

objs/t-decimal.o:     $R/t-decimal.c
	$(CC) $R/t-decimal.c $(RFLAGS) -o objs/t-decimal.o

objs/t-event.o:       $R/t-event.c
	$(CC) $R/t-event.c $(RFLAGS) -o objs/t-event.o

objs/t-function.o:    $R/t-function.c
	$(CC) $R/t-function.c $(RFLAGS) -o objs/t-function.o

objs/t-gob.o:         $R/t-gob.c
	$(CC) $R/t-gob.c $(RFLAGS) -o objs/t-gob.o

objs/t-image.o:       $R/t-image.c
	$(CC) $R/t-image.c $(RFLAGS) -o objs/t-image.o

objs/t-integer.o:     $R/t-integer.c
	$(CC) $R/t-integer.c $(RFLAGS) -o objs/t-integer.o

objs/t-logic.o:       $R/t-logic.c
	$(CC) $R/t-logic.c $(RFLAGS) -o objs/t-logic.o

objs/t-map.o:         $R/t-map.c
	$(CC) $R/t-map.c $(RFLAGS) -o objs/t-map.o

objs/t-money.o:       $R/t-money.c
	$(CC) $R/t-money.c $(RFLAGS) -o objs/t-money.o

objs/t-none.o:        $R/t-none.c
	$(CC) $R/t-none.c $(RFLAGS) -o objs/t-none.o

objs/t-object.o:      $R/t-object.c
	$(CC) $R/t-object.c $(RFLAGS) -o objs/t-object.o

objs/t-pair.o:        $R/t-pair.c
	$(CC) $R/t-pair.c $(RFLAGS) -o objs/t-pair.o

objs/t-port.o:        $R/t-port.c
	$(CC) $R/t-port.c $(RFLAGS) -o objs/t-port.o

objs/t-string.o:      $R/t-string.c
	$(CC) $R/t-string.c $(RFLAGS) -o objs/t-string.o

objs/t-time.o:        $R/t-time.c
	$(CC) $R/t-time.c $(RFLAGS) -o objs/t-time.o

objs/t-tuple.o:       $R/t-tuple.c
	$(CC) $R/t-tuple.c $(RFLAGS) -o objs/t-tuple.o

objs/t-typeset.o:     $R/t-typeset.c
	$(CC) $R/t-typeset.c $(RFLAGS) -o objs/t-typeset.o

objs/t-utype.o:       $R/t-utype.c
	$(CC) $R/t-utype.c $(RFLAGS) -o objs/t-utype.o

objs/t-vector.o:      $R/t-vector.c
	$(CC) $R/t-vector.c $(RFLAGS) -o objs/t-vector.o

objs/t-word.o:        $R/t-word.c
	$(CC) $R/t-word.c $(RFLAGS) -o objs/t-word.o

objs/u-aes.o:         $R/u-aes.c
	$(CC) $R/u-aes.c $(RFLAGS) -o objs/u-aes.o

objs/u-bigint.o:      $R/u-bigint.c
	$(CC) $R/u-bigint.c $(RFLAGS) -o objs/u-bigint.o

objs/u-bincode.o:     $R/u-bincode.c
	$(CC) $R/u-bincode.c $(RFLAGS) -o objs/u-bincode.o

objs/u-bmp.o:         $R/u-bmp.c
	$(CC) $R/u-bmp.c $(RFLAGS) -o objs/u-bmp.o

objs/u-chacha20.o:    $R/u-chacha20.c
	$(CC) $R/u-chacha20.c $(RFLAGS) -o objs/u-chacha20.o

objs/u-compress.o:    $R/u-compress.c
	$(CC) $R/u-compress.c $(RFLAGS) -o objs/u-compress.o

objs/u-dh.o:          $R/u-dh.c
	$(CC) $R/u-dh.c $(RFLAGS) -o objs/u-dh.o

objs/u-dialect.o:     $R/u-dialect.c
	$(CC) $R/u-dialect.c $(RFLAGS) -o objs/u-dialect.o

objs/u-gif.o:         $R/u-gif.c
	$(CC) $R/u-gif.c $(RFLAGS) -o objs/u-gif.o

objs/u-iconv.o:       $R/u-iconv.c
	$(CC) $R/u-iconv.c $(RFLAGS) -o objs/u-iconv.o

objs/u-image-resize.o:$R/u-image-resize.c
	$(CC) $R/u-image-resize.c $(RFLAGS) -o objs/u-image-resize.o

objs/u-jpg.o:         $R/u-jpg.c
	$(CC) $R/u-jpg.c $(RFLAGS) -o objs/u-jpg.o

objs/u-lzma.o:        $R/u-lzma.c
	$(CC) $R/u-lzma.c $(RFLAGS) -o objs/u-lzma.o

objs/u-parse.o:       $R/u-parse.c
	$(CC) $R/u-parse.c $(RFLAGS) -o objs/u-parse.o

objs/u-png.o:         $R/u-png.c
	$(CC) $R/u-png.c $(RFLAGS) -o objs/u-png.o

objs/u-poly1305.o:    $R/u-poly1305.c
	$(CC) $R/u-poly1305.c $(RFLAGS) -o objs/u-poly1305.o

objs/u-rc4.o:         $R/u-rc4.c
	$(CC) $R/u-rc4.c $(RFLAGS) -o objs/u-rc4.o

objs/u-rsa.o:         $R/u-rsa.c
	$(CC) $R/u-rsa.c $(RFLAGS) -o objs/u-rsa.o

objs/u-uECC.o:        $R/u-uECC.c
	$(CC) $R/u-uECC.c $(RFLAGS) -o objs/u-uECC.o

objs/u-zlib.o:        $R/u-zlib.c
	$(CC) $R/u-zlib.c $(RFLAGS) -o objs/u-zlib.o

objs/u-wav.o:         $R/u-wav.c
	$(CC) $R/u-wav.c $(RFLAGS) -o objs/u-wav.o

objs/u-mbedtls.o:     $R/u-mbedtls.c
	$(CC) $R/u-mbedtls.c $(RFLAGS) -o objs/u-mbedtls.o

objs/mbedtls/platform.o:$R/mbedtls/platform.c
	$(CC) $R/mbedtls/platform.c $(RFLAGS) -o objs/mbedtls/platform.o

objs/mbedtls/platform_util.o:$R/mbedtls/platform_util.c
	$(CC) $R/mbedtls/platform_util.c $(RFLAGS) -o objs/mbedtls/platform_util.o

objs/mbedtls/md4.o:   $R/mbedtls/md4.c
	$(CC) $R/mbedtls/md4.c $(RFLAGS) -o objs/mbedtls/md4.o

objs/mbedtls/md5.o:   $R/mbedtls/md5.c
	$(CC) $R/mbedtls/md5.c $(RFLAGS) -o objs/mbedtls/md5.o

objs/mbedtls/ripemd160.o:$R/mbedtls/ripemd160.c
	$(CC) $R/mbedtls/ripemd160.c $(RFLAGS) -o objs/mbedtls/ripemd160.o

objs/mbedtls/sha1.o:  $R/mbedtls/sha1.c
	$(CC) $R/mbedtls/sha1.c $(RFLAGS) -o objs/mbedtls/sha1.o

objs/mbedtls/sha256.o:$R/mbedtls/sha256.c
	$(CC) $R/mbedtls/sha256.c $(RFLAGS) -o objs/mbedtls/sha256.o

objs/mbedtls/sha512.o:$R/mbedtls/sha512.c
	$(CC) $R/mbedtls/sha512.c $(RFLAGS) -o objs/mbedtls/sha512.o

objs/host-main.o:     $S/os/host-main.c
	$(CC) $S/os/host-main.c $(HFLAGS) -o objs/host-main.o

objs/host-args.o:     $S/os/host-args.c
	$(CC) $S/os/host-args.c $(HFLAGS) -o objs/host-args.o

objs/host-device.o:   $S/os/host-device.c
	$(CC) $S/os/host-device.c $(HFLAGS) -o objs/host-device.o

objs/host-stdio.o:    $S/os/host-stdio.c
	$(CC) $S/os/host-stdio.c $(HFLAGS) -o objs/host-stdio.o

objs/dev-net.o:       $S/os/dev-net.c
	$(CC) $S/os/dev-net.c $(HFLAGS) -o objs/dev-net.o

objs/dev-dns.o:       $S/os/dev-dns.c
	$(CC) $S/os/dev-dns.c $(HFLAGS) -o objs/dev-dns.o

objs/host-ext-test.o: $S/os/host-ext-test.c
	$(CC) $S/os/host-ext-test.c $(HFLAGS) -o objs/host-ext-test.o

objs/host-lib.o:      $S/os/posix/host-lib.c
	$(CC) $S/os/posix/host-lib.c $(HFLAGS) -o objs/host-lib.o

objs/host-readline.o: $S/os/posix/host-readline.c
	$(CC) $S/os/posix/host-readline.c $(HFLAGS) -o objs/host-readline.o

objs/dev-stdio.o:     $S/os/posix/dev-stdio.c
	$(CC) $S/os/posix/dev-stdio.c $(HFLAGS) -o objs/dev-stdio.o

objs/dev-event.o:     $S/os/posix/dev-event.c
	$(CC) $S/os/posix/dev-event.c $(HFLAGS) -o objs/dev-event.o

objs/dev-file.o:      $S/os/posix/dev-file.c
	$(CC) $S/os/posix/dev-file.c $(HFLAGS) -o objs/dev-file.o

objs/dev-midi-osx.o:  $S/os/posix/dev-midi-osx.c
	$(CC) $S/os/posix/dev-midi-osx.c $(HFLAGS) -o objs/dev-midi-osx.o

