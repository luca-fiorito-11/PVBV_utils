import sys
import pandas as pd

widths=(4,4,5,6,3,12,12,12,11,8,13,12,12)
skiprows=list(range(0,26)) + [27]
df = pd.read_fwf(
         sys.argv[1],
         widths=widths,
         skiprows=skiprows,
         ).fillna(0)
table = df.to_html(index=False)
body = """---
layout: default
---
<body>
<h2>Integral values</h2>
{}  
</body>
""".format(table)
print(body)
