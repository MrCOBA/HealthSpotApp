import glob
import json
from os import path


PATH = 'parsed/vitamins'

data = []
for file in glob.glob(path.join(PATH, '*.json')):
    with open(file, 'r', encoding='utf-8') as fin:
        data.extend(json.load(fin))

print(f"Found {len(data)} items")
with open(path.join(PATH, 'all.json'), 'w', encoding='utf-8') as fout:
    json.dump(data, fout, indent=2, ensure_ascii=False)
