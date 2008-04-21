#!/usr/bin/env python

from distutils.core import setup

setup(
	name='pyRepRap',
	version='0.3',
	author='Stefan Blanke',
	author_email='greenarrow@users.sourceforge.net',
	description='Python library to control RepRap firmware using the SNAP protocol.',
	packages=['reprap'],
	scripts=['scripts/rrplotdxf']
)
