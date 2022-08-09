* compiled with flags
```
CFLAGS="-march=armv8-a+crc+crypto -mtune=cortex-a72"
echo "APPEND CFLAGS ${CFLAGS}" >> /etc/dpkg/buildflags.conf
echo "APPEND CXXFLAGS ${CFLAGS}" >> /etc/dpkg/buildflags.conf
```
