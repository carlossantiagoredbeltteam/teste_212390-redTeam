## Copyright (C) 2008 James Vasile <james@hackervisions.org>

## This is a freed work; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## any later version.

## This is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
## or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
## License for more details.  You should have received a copy of the
## GNU General Public License along with the work; if not, write
## to the Free Software Foundation, Inc., 51 Franklin Street, 5th
## Floor, Boston, MA 02110-1301 USA

BASE= geegaw
LIBDIR= /home/vasile/personal/reprap/users/vasile/brlcad/

SRC= $(BASE).py
TARGET= $(BASE).g
MGEDBIN= /usr/brlcad/bin/mged
PYTHONBIN= /usr/bin/python


$(TARGET): Makefile $(SRC) $(LIBDIR)/brlcad.py $(LIBDIR)/brlcad_mechanical.py
	$(PYTHONBIN) $(SRC) > $(BASE).brlcad

clean:
	rm $(TARGET)
