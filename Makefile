# menu
MENU=./lib/dialog/menu
CONF=./lib/dialog/config
DIALOGRC=$(shell cp -f lib/dialogrc ~/.dialogrc)

# rootfs
RFS=./scripts/rootfs
ROOTFS=sudo ./scripts/rootfs

# kernel
XLINUX=./scripts/rpi-linux
LINUX=sudo ./scripts/rpi-linux

# commit
XCOMMIT=./scripts/rpi-commit
COMMIT=sudo ./scripts/rpi-commit

# stages
STG1=./scripts/stage1
STG2=./scripts/stage2
IMAGE=sudo ./scripts/stage1

# clean
CLN=./scripts/clean
CLEAN=sudo ./scripts/clean

# purge
PURGE=$(shell sudo rm -fdr source)
PURGEALL=$(shell sudo rm -fdr source output)

# miscellaneous
XCHECK=./scripts/check
CHECK=./scripts/check
XRUN=./scripts/run-linux
RUN=./scripts/run-linux
XCOMP=./scripts/compress
COMP=sudo ./scripts/compress

# dependencies
CCOMPILE=./scripts/.ccompile
CCOMPILE64=./scripts/.ccompile64
NCOMPILE=./scripts/.ncompile

# boards
BOARDS=$(shell sudo cp lib/boards/${board} board.txt)

ifdef board
include lib/boards/${board}
endif

define build_kernel
	@${BOARDS}
	@chmod +x ${XLINUX}
	@${LINUX}
endef

define build_commit
	@${BOARDS}
	@chmod +x ${XCOMMIT}
	@${COMMIT}
endef

define build_image
	@${BOARDS}
	@chmod +x ${STG1}
	@chmod +x ${STG2}
	@${IMAGE}
endef

define create_rootfs
	@${BOARDS}
	@chmod +x ${RFS}
	@${ROOTFS}
endef

help:
	@echo ""
	@echo "\t\t\e[1;31mRaspberry Pi Image Builder\e[0m"
	@echo "\t\t\e[1;37m**************************\e[0m"
	@echo ""
	@echo "\e[1;37mBoards:\e[0m"
	@echo "   bcm2711\t\t\tRaspberry Pi 4B/400 (arm64)"
	@echo "   bcm2711v7\t\t\tRaspberry Pi 4B/400 (armhf)"
	@echo "   bcm2710\t\t\tRaspberry Pi 2/3/A/B/W/+ (arm64)"
	@echo "   bcm2709\t\t\tRaspberry Pi 2/3/A/B/W/+ (armhf)"
	@echo "   bcm2708\t\t\tRaspberry Pi 0/W/B/+ (armel)"
	@echo ""
	@echo "\e[1;37mCommands:\e[0m"
	@echo "   make ccompile\t\tInstall x86-64 cross dependencies"
	@echo "   make ccompile64\t\tInstall Arm64 cross dependencies"
	@echo "   make ncompile\t\tInstall native dependencies"
	@echo "   make config\t\t\tCreate user data file"
	@echo "   make menu\t\t\tUser menu interface"
	@echo "   make cleanup\t\t\tClean up rootfs and image errors"
	@echo "   make purge\t\t\tRemove source directory"
	@echo "   make purge-all\t\tRemove source and output directory"
	@echo "   make dialogrc\t\tSet builder theme"
	@echo "   make check\t\t\tLatest revision of selected branch"
	@echo ""
	@echo "   make all board=xxx\t\tKernel > rootfs > image"
	@echo "   make kernel board=xxx\tBuilds linux kernel package"
	@echo "   make rootfs board=xxx\tCreate rootfs tarball"
	@echo "   make image board=xxx\t\tMake bootable image"
	@echo ""

ccompile:
	# Installing x86_64 cross dependencies:
	@chmod +x ${CCOMPILE}
	@${CCOMPILE}
	
ccompile64:
	# Installing arm64 cross dependencies:
	@chmod +x ${CCOMPILE64}
	@${CCOMPILE64}

ncompile:
	# Installing native dependencies:
	@chmod +x ${NCOMPILE}
	@${NCOMPILE}

# builder
kernel:
	# Compiling kernel
	$(call build_kernel)

commit:
	# Compiling kernel
	$(call build_commit)

image:
	# Creating image
	$(call build_image)

all:
	# Compiling kernel
	$(call build_kernel)
	# Creating ROOTFS tarball
	$(call create_rootfs)
	# Creating image
	$(call build_image)

# rootfs
rootfs:
	# ROOTFS
	$(call create_rootfs)

# clean and purge
cleanup:
	# Cleaning up
	@chmod +x ${CLN}
	@${CLEAN}

purge:
	# Removing source directory
	@${PURGE}

purge-all:
	# Removing source and output directory
	@${PURGEALL}

# miscellaneous
dialogrc:
	# Builder theme set
	@${DIALOGRC}

check:
	# Check kernel revisions
	@chmod +x ${XCHECK}
	@${CHECK}

# kernel run
run:
	@chmod +x ${XRUN}
	@${RUN}

compress:
	@chmod +x ${XCOMP}
	@${COMP}

# menu
menu:
	# User menu interface
	@chmod +x ${MENU}
	@${MENU}

config:
	# User config menu
	@chmod go=rx files/inits/*
	@chmod go=rx files/scripts/*
	@chmod go=r files/misc/*
	@chmod go=r files/users/*
	@chmod +x ${CONF}
	@${CONF}
