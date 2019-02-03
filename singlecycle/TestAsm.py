#!/usr/bin/python3

import os
import fnmatch
import subprocess

pattern = 'test.*.asm'
path = './asmFiles'

for dirpath, dirnames, filenames in os.walk(path):

    if not filenames:
        continue

    test_asm_files = fnmatch.filter(filenames, pattern)
    if test_asm_files:
        for file in test_asm_files:
            subprocess.call(["asm", str(dirpath + '/' + file)])
            with open('/dev/null', 'w+') as trash:
            	subprocess.call(["make", 'system.sim'], stdout=trash)

            output_file = str(dirpath + '/output/' + file + '.output')
            subprocess.call(["cp", 'memcpu.hex', output_file])

            with open(output_file, 'a+') as of:
            	of.write("\ndiff:\n")
            	of.write("=================================\n")
            with open(output_file, 'a+') as of:
            	subprocess.call(['diff', 'meminit.hex', 'memcpu.hex'], stdout=of)
            # print("output:", str(dirpath + '/output/' + file + '.output'))
            # subprocess.call(["make", 'system.sim'], stdout=str(dirpath + '/output/' + file + '.output'))
            # print('{}/{}'.format(dirpath, file))