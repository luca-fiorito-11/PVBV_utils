import openmc
import sys
import pandas as pd

EV = openmc.data.endf.Evaluation(sys.argv[1])
info = EV.info
del info['description']
del info['identifier']
info["library"] = info["library"][0] + "-" + str(info["library"][1]) + "." + str(info["library"][2])
info = dict(info, **EV.target)
# Add links to other codes' outputs
info["NJOY output"] = "<a href=\"njoy_output.html\">here</a>"
info["INTER output"] = "<a href=\"inter_output.html\">here</a>"
name = info.pop("zsymam")

df = pd.Series(info).rename(name.strip()).to_frame()

table = df.to_html(escape=False, justify="left")
body = """---
layout: default
---
<body>
{}  
</body>
""".format(table)
print(body)
