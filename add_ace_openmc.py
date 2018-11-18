#!/usr/bin/env python3

import os
from collections import defaultdict
import sys
import tarfile
import zipfile
import glob
import argparse
from string import digits
from urllib.request import urlopen

import openmc.data
import pdb


class CustomFormatter(argparse.ArgumentDefaultsHelpFormatter,
                      argparse.RawDescriptionHelpFormatter):
    pass


parser = argparse.ArgumentParser(
    formatter_class=CustomFormatter
)
parser.add_argument('-b', '--batch', action='store_true',
                    help='supresses standard in')
parser.add_argument('source',
                    help='Directory where to find ace files')
parser.add_argument('-d', '--destination',
                    default='jeff-3.3-hdf5',
                    help='Directory to create new library in')
parser.add_argument('--libver',
                    choices=['earliest', 'latest'],
                    default='latest',
                    help="Output HDF5 versioning. Use "
                    "'earliest' for backwards compatibility or 'latest' for "
                    "performance")
parser.add_argument('-e','--extension',
                    default='ace',)
args = parser.parse_args()



# Get a list of all ACE files
neutron_files = glob.glob(os.path.join(args.source, '**', '*.{}'.format(args.extension)), recursive=True)


# Group together tables for same nuclide
tables = defaultdict(list)
for filename in sorted(neutron_files):
    dirname, basename = os.path.split(filename)
    name = basename.split('.')[0]
    tables[name].append(filename)

try:
   library = openmc.data.DataLibrary.from_xml()
except:
   library = openmc.data.DataLibrary()

for name, filenames in sorted(tables.items()):
    # Convert first temperature for the table
    print('Converting: ' + filenames[0])
    data = openmc.data.IncidentNeutron.from_ace(filenames[0])

    # For each higher temperature, add cross sections to the existing table
    for filename in filenames[1:]:
        print('Adding: ' + filename)
        data.add_temperature_from_ace(filename)

    # Export HDF5 file
    h5_file = os.path.join(args.destination, data.name + '.h5')
    print('Writing {}...'.format(h5_file))
    data.export_to_hdf5(h5_file, 'w', libver=args.libver)

    # Register with library
    library.register_file(h5_file)

# Write cross_sections.xml
libpath = os.path.join(args.destination, 'cross_sections.xml')
library.export_to_xml(libpath)
