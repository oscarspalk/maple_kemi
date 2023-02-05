## Installation

### Windows
Open a CMD in admin and navigate to your maple installation directory, then run:
```bash
curl -o lib/kemi.mla https://github.com/oscarspalk/maple_kemi/blob/dll/kemi.mla?raw=true &
cd data & mkdir kemi &
curl -o kemi/elements.json https://raw.githubusercontent.com/oscarspalk/maple_kemi/dll/kemi/elements.json &
curl -o kemi/kemilib.dll https://github.com/oscarspalk/maple_kemi/blob/dll/kemi/kemilib.dll?raw=true
```
### Linux
Open a CMD and run with sudo, navigate to your maple directory and run:
```bash
curl -o lib/kemi.mla https://github.com/oscarspalk/maple_kemi/blob/dll/kemi.mla?raw=true &&
cd data && mkdir kemi &&
curl -o kemi/elements.json https://raw.githubusercontent.com/oscarspalk/maple_kemi/dll/kemi/elements.json &&
curl -o kemi/kemilib.dll https://github.com/oscarspalk/maple_kemi/blob/dll/kemi/kemilib.dll?raw=true
```