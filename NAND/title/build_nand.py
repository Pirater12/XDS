#!/usr/bin/env python
import glob
import os
import sys

def main():
  if len(sys.argv) < 2:
    print 'invalid directory specified'
    return

  for i in os.listdir(sys.argv[1]):
    tid_high = i[0:8]
    tid_low = i[8:16]
    outdir = os.path.join('.', tid_high, tid_low, 'content')
    if not os.path.exists(outdir):
      os.makedirs(outdir)
    cia = os.path.join(sys.argv[1], i)
    os.system("ctrtool --tmd=" + outdir + "/00000000.tmd --contents=" + outdir + "/contents '" + cia + "'")
    items = glob.glob(outdir + '/contents.*')
    for item in items:
      cid = item[-8:]
      os.rename(item, os.path.join(outdir,cid + '.app'))

if __name__ == "__main__":
  main()
