import json
import sys
import os
from os import path as osp

def powerset(s):
    x = len(s)
    masks = [1 << i for i in range(x)]
    for i in range(1 << x):
        yield [ss for mask, ss in zip(masks, s) if i & mask]

if __name__ == "__main__":
  fault_dir = json.load(open(osp.join(os.environ['D4J_HOME'],
      "framework/bin/config.json")))['FAULT_DIR']
  names = ["Chart", "Cli", "Closure", "Codec", "Collections", "Compress",
    "Csv", "Gson", "JacksonCore", "JacksonDatabind", "JacksonXml", "Jsoup",
    "JxPath", "Lang", "Math", "Mockito", "Time"]
  if (len(sys.argv) < 2 or sys.argv[1] not in names):
    print("USAGE: python dump_versions.py <project>")
    quit()
  name = sys.argv[1]
  f = open(osp.join(fault_dir,name+".json"))
  js = json.loads(f.read())
  for key in js.keys():
    faults = [int(key)]
    for val in js[key].keys():
      if (val != key):
        faults.append(int(val))
    faults.sort()
    s = name
    for fault in faults:
        s += "-"+str(fault)
    print(s)


