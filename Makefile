NAME=csv2json
standalone: pyc
	nuitka3 --plugin-enable=pyside2 --include-qt-plugins --standalone ${NAME}.py

pyc:
	hy2py ${NAME}.hy > ${NAME}.py
