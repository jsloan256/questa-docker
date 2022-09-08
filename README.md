# Description
This Docker image provides Questa simulator from Intel's Quartus Lite 21.1.1. The image is based on CentOS 8.

# Required Files
The following files must be downloaded and placed in this folder before building the docker image
1. [QuestaSetup-21.1.1.850-linux.run](https://downloads.intel.com/akdlm/software/acdsinst/21.1std.1/850/ib_tar/Quartus-lite-21.1.1.850-linux.tar))
2. [LR-093014_License.dat](https://licensing.intel.com/)

# Build the Docker Image
```console
docker build -t questa:21.1.1 .
```

# Run the Docker Image
```console
docker run -ti -e "TERM=xterm-256color" --network=host -e DISPLAY=$DISPLAY -v $HOME/dev/:/home/questa/dev/ --name questa21.1.1 questa:21.1.1
```

# Connect to an existing Docker Image
```console
docker exec -e "TERM=xterm-256color" -ti questa21.1.1 /bin/bash
```

# Export (save) Docker Image to file
```console
docker save questa:22.1.1 | gzip > questa.21.1.1.tar.gz
```
