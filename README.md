# RaspDAB
An ODR-mmbtools automated DAB+ micro transmitter using Raspberry Pi and EasyDab v2

Nowadays to transmit a DAB+ ensemble requires little more than 
- the OpenDigitalRadio mmbtools software
- a Raspberry Pi, and
- an EasyDAB v2 board

![Photo of a RaspDAB setup](https://github.com/glokhoff/RaspDAB/blob/master/20170222_120621.jpg)

This project aims to provide documentation how to build such a 'micro transmitter' which could be used as the starting point for a low cost DAB+ transmitter for e.g. local radio. It is based on experience from building a system, starting from getting the Raspbian operating system installed, installing the OpenDigitalRadio programs required, configuring and using these, installing supervisor to enable automatic start up and configuring and using the EasyDAB v2 DAB modulator board.

As I'm not that experienced using Linux there were some unexpected hurdles that I needed to overcome. It might just help others to document how it was done, so it is easier for them. 

# Installation

The documentation explains the steps taken to install all necessary software on the Raspberry Pi. To install the ODR mmbtools the debian.sh script has been modified as the modulation is performed with the EasyDAB board, so the software for modulation is not installed.

# Usage

The project aims to enable operation with modules located at different locations: 
- Audio and Program Associated Data encoding at the source, e.g. the radio studio, or via a stream received at the location of the multiplex generation;
- Multiplex generation for a number of radio stations at a location with a high bandwidth and stable Internet connection;
- Modulation at the transmission site using EasyDAB.
Ofcourse it is also possible to have everything together on one table.

# Documentation

Most documentation can be found in the [Wiki](https://github.com/glokhoff/RaspDAB/wiki). Some examples and script files will be in the code section.

# Contributing

Additions and corrections are welcome !

# Credits

The project is fully based on the results from
- developers of the [Raspberry Pi](https://www.raspberrypi.org/) and [Raspbian](http://www.raspbian.org/) 
- developers in the [OpenDigitalRadio](http://www.opendigitalradio.org/) project
- Sergiy from Kiev who developed the [EasyDAB v2](http://tipok.org.ua/node/46) board

Big thank you to them to making DAB transmission this easy !

# License

The documentation in this project is offered under the Creative Commons Zero v1.0 Universal license.
(But would be nice if you mention the source ;o) )
