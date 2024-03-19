# Poky

## Steps to build

```sh
docker build . -t yocto
```

## Steps to run

```sh
docker run -it -v ./output:/home/build/output yocto
```

## Inside the container execute

```sh
cd /yocto
source oe-init-build-env build
bitbake core-image-minimal
cp tmp/deploy/images/qemux86-64/core-image-minimal-qemux86-64.ext4 /home/build/output/
```

## Run the QEMU Image

```sh
qemu-system-x86_64 -hda output/core-image-minimal-qemux86-64.ext4
```
