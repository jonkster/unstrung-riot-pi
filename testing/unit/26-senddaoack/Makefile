UNSTRUNG_SRCDIR?=$(shell cd ../../..; pwd)

include ${UNSTRUNG_SRCDIR}/Makefile.inc
include ${srcdir}../Makefile.testing

export SENDDAO=${UNSTRUNG_OBJDIR}/programs/senddao/senddao
PCAP01=../OUTPUTS/senddaoack-test-01out.pcap

checkprograms::
programs::
clean::
	@rm -f core.*
	@rm -rf OUTPUT

check::
	@rm -f core.*
	@${SENDDAO} --fake --outpcap ${PCAP01} -i wlan0 -v --instance 43 --dagid thisismydicedag2 --daoack 11 --sequence 11 >../OUTPUTS/senddaoack-test-01.raw 2>&1
	@diff -B -w ../OUTPUTS/senddaoack-test-01.raw senddaoack-test-01.txt
	@${TCPDUMP} -t -n -r ${PCAP01} -v -v -v >../OUTPUTS/senddaoack-test-01-pcap.txt
	@diff ../OUTPUTS/senddaoack-test-01-pcap.txt  senddaoack-test-01-pcap.txt
	@if [ -f core.* ]; then echo CORE FILES FOUND; exit 1; else exit 0; fi

update:
	cp ../OUTPUTS/senddaoack-test-01.raw         senddaoack-test-01.txt
	cp ../OUTPUTS/senddaoack-test-01-pcap.txt    senddaoack-test-01-pcap.txt
