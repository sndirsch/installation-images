# perl libraries & binaries
PLIBS	= AddFiles MakeFATImage MakeMinixImage ReadConfig
PBINS	= initrd_test mk_boot mk_initrd mk_initrd_test mk_root mk_yast2\
          mk_yast2_cd mk_yast2_nfs

.PHONY: all dirs initrd initrd_test boot boot_axp root yast2 yast2_cd nfs html clean distdir install

all:

install:

distdir: clean
	@mkdir -p $(distdir)
	@tar -cf - . | tar -C $(distdir) -xpf -
	@find $(distdir) -depth -name CVS -exec rm -r {} \;

dirs:
	@[ -d images ] || mkdir images
	@[ -d test ] || mkdir test
	@[ -d tmp ] || mkdir tmp

initrd: dirs
	bin/mk_initrd

initrd_test: initrd
	bin/mk_initrd_test
	@echo "now, run bin/initrd_test"

boot: initrd
	bin/mk_boot

boot_axp: initrd
	bin/mk_boot_axp

root: dirs
	bin/mk_root

yast2: dirs
	bin/mk_yast2

yast2_cd: boot yast2
	bin/mk_yast2_cd

yast2_nfs: boot yast2
	bin/mk_yast2_nfs

html:
	@for i in $(PLIBS); do echo $$i; pod2html --noindex --title=$$i --outfile=doc/$$i.html lib/$$i.pm; done
	@for i in $(PBINS); do echo $$i; pod2html --noindex --title=$$i --outfile=doc/$$i.html bin/$$i; done
	@rm pod2html-dircache pod2html-itemcache

clean:
	-@umount test/initdisk/proc
	-@umount test/initdisk/mnt
	-@rm -rf images test tmp
	-@rm -f *~ */*~
