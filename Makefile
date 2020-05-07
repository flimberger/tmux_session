PROG=	tmux_session

INSTALL=	/usr/bin/install

install:
	${INSTALL} ${PROG} ${DESTDIR}${BINDIR}/${PROG}
.PHONY:	install
