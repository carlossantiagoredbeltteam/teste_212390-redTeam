#!/usr/bin/env python

from distutils.core import setup

setup(
	name='pyRepRap',
	version='0.3',
	author='Stefan Blanke',
	author_email='greenarrow@users.sourceforge.net',
	description='Python library to control RepRap firmware using the SNAP protocol.',
	packages=['reprap'],
	scripts=['scripts/reprapcontrol', 'scripts/reprapplot'],
	data_files = [( 'share/reprap/icons', ['reprap/graphics/reprap.png', 'reprap/graphics/connect_established.png', 'reprap/graphics/media-playback-stop.png', 'reprap/graphics/connect_no.png', 'reprap/graphics/go-home.png', 'reprap/graphics/document-open.png', 'reprap/graphics/media-playback-start.png'] )]
)


