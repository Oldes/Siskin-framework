# Preparing enivirnonment on Linux 

Red is now only 32bit, so we must have at least `libc6` and `libcurl3` 32 bit libs to run Red console. Run these commands to install them:

```
sudo dpkg --add-architecture i386;
sudo apt-get update;
sudo apt-get install -y libc6:i386 libcurl3:i386;
```

To compile Red, Rebol (www.rebol.com) is needed... you can install it using:

```
wget http://static.red-lang.org/tmp/rebol; chmod +x rebol; sudo mv ./rebol /usr/local/bin/rebol2;
```