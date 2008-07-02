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
	data_files = [
		( 'share/reprap/icons',
			['reprap/graphics/reprap.png',
			'reprap/graphics/connect_established.png',
			'reprap/graphics/media-playback-stop.png',
			'reprap/graphics/connect_no.png',
			'reprap/graphics/go-home.png',
			'reprap/graphics/document-open.png',
			'reprap/graphics/media-playback-start.png'] ),
		( 'share/applications',
			['reprap/misc/reprapplot.desktop'] ),
		( 'share/reprap/plugins/import',
			['reprap/plugins/import/dxf_lib.py',
			'reprap/plugins/import/dxf_import.py',
			'reprap/plugins/import/dxf_prefpanel.py',
			'reprap/plugins/import/gerber_lib.py',
			'reprap/plugins/import/gerber_import.py',
			'reprap/plugins/import/gerber_prefpanel.py',
			'reprap/plugins/import/svg_lib.py',
			'reprap/plugins/import/svg_import.py',
			'reprap/plugins/import/svg_prefpanel.py',
			'reprap/plugins/import/smil_lib.py',
			'reprap/plugins/import/smil_import.py',
			'reprap/plugins/import/smil_prefpanel.py'] ),
		( 'share/reprap/plugins/toolhead',
			['reprap/plugins/toolhead/pen_toolhead.py',
			'reprap/plugins/toolhead/pen_prefpanel.py',
			'reprap/plugins/toolhead/router_toolhead.py'] ),
		( 'share/reprap/plugins/output',
			['reprap/plugins/output/reprap_output.py',
			'reprap/plugins/output/reprap_prefpanel.py',
			'reprap/plugins/output/smil_output.py',
			'reprap/plugins/output/smil_prefpanel.py',
			'reprap/plugins/output/svg_output.py',
			'reprap/plugins/output/gcode_output.py',
			'reprap/plugins/output/gcode_prefpanel.py'] )
	]
)


