import sys
import pandas as pd

widths=(4,4,5,6,3,12,12,12,11,8,13,12,12)
df = pd.read_fwf(
         sys.argv[1],
         widths=widths,
         skiprows=[1],
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
