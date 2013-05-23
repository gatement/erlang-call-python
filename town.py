import sys

def handle(string0):
    if string0.startswith("combine|"):
        string = "".join( string0[8:].split(","))
        return string
 
"""waiting for input """
while 1:
    # Receive Binary Stream from Standard In
    inStream = sys.stdin.readline()
    if not inStream: break

    # Scheme, Turn into  Formal String
    inString  = inStream.strip("\r\n")

    # handle String
    outString = handle(inString)

    # send to port as Standart OUT
    sys.stdout.write("%s\n" % (outString,))
    sys.exit(0)
