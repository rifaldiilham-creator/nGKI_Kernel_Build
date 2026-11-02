#!/usr/bin/env bash
set -euo pipefail

FILE="$GITHUB_WORKSPACE/device_kernel/drivers/kernelsu/kernel_includes.h"
test -f "$FILE"

python3 - "$FILE" <<'PY'
import pathlib
import sys

p = pathlib.Path(sys.argv[1])
s = p.read_text()

old = "#include <linux/static_call.h>"
new = """#include <linux/version.h>
#if LINUX_VERSION_CODE >= KERNEL_VERSION(6, 12, 0)
#include <linux/static_call.h>
#endif"""

if new in s:
    print("Already patched")
elif s.count(old) == 1:
    p.write_text(s.replace(old, new, 1))
    print("SukiSU compatibility patch applied")
else:
    raise SystemExit("ERROR: Unexpected kernel_includes.h content")
PY
