# 	Copyright (c) 2013 Peter V. Saveliev
#
# 	This file is part of pyroute2 project.
#
# 	PyVFS is free software; you can redistribute it and/or modify
# 	it under the terms of the GNU General Public License as published by
# 	the Free Software Foundation; either version 2 of the License, or
# 	(at your option) any later version.
#
# 	PyVFS is distributed in the hope that it will be useful,
# 	but WITHOUT ANY WARRANTY; without even the implied warranty of
# 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# 	GNU General Public License for more details.
#
# 	You should have received a copy of the GNU General Public License
# 	along with PyVFS; if not, write to the Free Software
# 	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

version ?= "0.1"
release ?= "0.1.3"
python ?= "python"

ifdef root
	override root := "--root=${root}"
endif

ifdef lib
	override lib := "--install-lib=${lib}"
endif


all:
	@echo targets: dist, install

clean: clean-version
	rm -rf dist build MANIFEST
	find . -name "*pyc" -exec rm -f "{}" \;

check:
	for i in pyroute2 ; \
		do pep8 $$i || exit 1; \
		pyflakes $$i || exit 1; \
		done

setup.py:
	gawk -v version=${version} -v release=${release} -v flavor=${flavor}\
		-f configure.gawk $@.in >$@

clean-version:
	rm -f setup.py

force-version: clean-version update-version

update-version: setup.py

upload: clean force-version
	${python} setup.py sdist upload 

dist: clean force-version
	${python} setup.py sdist

install: clean force-version
	${python} setup.py install ${root} ${lib}

