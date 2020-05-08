PROG =	tmux_session
MAN =	${PROG}.1

INSTALL =	/usr/bin/install
MANDOC =	mandoc

install:
	${INSTALL} -m 0550 ${PROG} ${DESTDIR}${BINDIR}/${PROG}
	${INSTALL} -m 0222 ${MAN} ${DESTDIR}${MANDIR}/man1/${MAN}
.PHONY:	install

lint:
	${MANDOC} -Tlint ${MAN}
.PHONY:	lint
