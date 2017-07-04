#!/usr/bin/env python3

from Bio import SeqIO
import os
import subprocess
import tompytools

# readlength script
readlength = 'bin/bbmap/readlength.sh'

# IO files
read_files = tompytools.find_all(['.trimmed.fq'], 'output/proovread')
outdir = 'output/trimmed_reads'
if not os.path.isdir(outdir):
    os.mkdir(outdir)

sorted_fastq = os.path.join(outdir, 'long_reads.trimmed_sorted.fastq')

# parse files
records = []
for file in read_files:
    for record in SeqIO.parse(file, 'fastq'):
        records.append(record)

# sort the records by length
ordered_records = reversed(sorted(records, key=len))

# print output
SeqIO.write(sequences=ordered_records,
            handle=sorted_fastq,
            format='fastq')

# call readlength.sh
cmd = [readlength,
       'in=' + sorted_fastq,
       'out=' + os.path.join(outdir, 'rlhist.txt')]
proc = subprocess.Popen(cmd,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE)
out, err = proc.communicate()
with open(os.path.join(outdir, 'reformat.log'), 'wb') as f:
    f.write(err)
