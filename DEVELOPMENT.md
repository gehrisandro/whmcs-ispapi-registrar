## Development instructions for hosttech

### Install submodules
```bash
git submodule init
git submodule update
cd modules/registrars/ispapi/lib
git submodule init
git submodule update
```

### Run commands through docker
```bash
docker run -it -v `pwd`:`pwd` -w `pwd` node <COMMAND>
```

### npm install
```bash
docker run -it -v `pwd`:`pwd` -w `pwd` node npm install
```

### Update Version
```bash
docker run -it -v `pwd`:`pwd` -w `pwd` node bash -c './updateVersion.sh <VERSION>'
```

### Build
```bash
docker run -it -v `pwd`:`pwd` -w `pwd` node gulp release
```

