import json
import sys
import os
from os import path as osp

fault_dir = json.load(open(osp.join(os.environ['D4J_HOME'],
                      "framework/bin/scripts/config.json")))['FAULT_DIR']


def powerset(s):
    x = len(s)
    masks = [1 << i for i in range(x)]
    for i in range(1 << x):
        yield [ss for mask, ss in zip(masks, s) if i & mask]


def get_versions(project, print_all=False):
    vs = []
    if (not osp.isfile(osp.join(fault_dir, project+".json"))):
        print("ERROR: project", project, "not found")
        quit()
    sys.path.append(osp.join(os.environ['D4J_HOME'], "framework", "bin",
                             "scripts"))
    from backtrack import backtrack
    test_case_versions = open(osp.join(fault_dir, project+".json"))
    js = json.loads(test_case_versions.read())

    location_versions = open(osp.join(fault_dir, project+"_backtrack.json"))
    loc_js = json.loads(location_versions.read())

    for key in js.keys():
        faults = [int(key)]
        for val in js[key].keys():
            if (val != key):
                faults.append(int(val))
        faults.sort()
        s = (project, [])
        for fault in faults:
            if (print_all or not backtrack(project, str(fault),
                str(key)).startswith("Bug not found")):
                s[1].append(fault)
        vs.append(s)
    return vs


if __name__ == "__main__":
    if (len(sys.argv) < 2):
        print("USAGE: python dump_versions.py <project> [all]")
        quit()
    project = sys.argv[1]
    print_all = False
    if (len(sys.argv) > 2 and sys.argv[2] == "all"):
        print_all = True
    versions = get_versions(project, print_all)
    for v in versions:
        print(v[0], *v[1], sep="-")
