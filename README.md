# MyPrecious: a Modular Middleware
I started this project after years of using or contributing to the development several middlewares including [rST](http://wiki.squeak.org/squeak/2288), [UbiquiTalk](https://www.slideshare.net/nourybouraqadi/ubiquitalk-an-infrastructure-for-ubiquitous-computing-esug-2006), [PhaROS](https://github.com/CARMinesDouai/PhaROS), [Simple Middleware](https://github.com/bouraqadi/PharoMisc/tree/master/SimpleMiddleware), or [PharoJS Bridge](https://github.com/bouraqadi/pharojs). All these middleware difinitely share many concepts, and complement each other. 

Modularity is THE keyword behind *MyPrecious*. It should make it easy to implement most features and concepts from other middlewares listed above or others. For example, communication can be done via TCP as in Seamless or rST. It can be done also via UDP, web sockets, a shared memory, or even some other middleware such as [ROS](https://ros.org).

At the time of writing, this is just a plan, still to be implemented an validated for real.

## [Documentation](Doc.md)

## Install
To install evaluate the following expression in a Playground
```Smalltalk
Metacello new
  baseline: 'MyPrecious';
  repository: 'github://bouraqadi/MyPrecious:pharo9';
  load
 ```
