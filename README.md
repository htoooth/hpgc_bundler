# hpgc_bundler

This bundler include gdal, geos, proj4, postgis, postgresql, protobuf, openmpi and ssdb.

## How to use

`git clone https://github.com/htoooth/hpgc_bundler.git`

then `cd hpgc_bundler`

type `rake -T`

type `rake install[you/path]`

## change log

* 20141129_1250

```
update openmpi from 1.6.5 to 1.8.3
```

* 20141128_1701

```
add boost 1.57.0
```

* 20141128_1604

```
remove geos 3.4.2 because it has a error when compile postgis
remove ssdb because don't need it.
remove gpref because don't need it.
```

* 20141128_1147

```
update postgis-2.1.4.tar.gz
```

* 20140504_1540

```
add geos-3.4.2.tar.bz2
add proj-4.8.0.tar.gz
add gdal-1.11.0.tar.gz
add openmpi-1.8.1.tar.gz
```

* 20141124_1401

```
add google libraries
```
