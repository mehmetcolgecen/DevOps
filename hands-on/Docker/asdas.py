import re
m = re.search(r"([a-z0-9])\1+([a-z0-9])\2+", "..1234567891011121314151666171820212223")
print(m.groups())