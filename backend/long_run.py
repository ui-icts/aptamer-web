from sys import argv
from time import sleep

defaults = [
    "Output",
    30,
    1
]

for index, arg in enumerate(argv[1:]):
    defaults[index] = arg

print "Executing with options %s" % defaults

text = defaults[0]
num = int(defaults[1])
seconds = int(defaults[2])

for i in range(0,num):
    print "SEEE %s %d" % (text, i)
    sleep(.25)


