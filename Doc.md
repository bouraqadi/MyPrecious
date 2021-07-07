# Documentation

## Overall Architecture

Facade pattern. Instances of `MpMiddleware` are facade objects.
A middleware is made of parts. Each part knows about the middleware it belongs to, so it can retrieve other parts if needed.
`MpMiddleware` is abstract. We create middleware as instances of its concrete subclasses.
Example of creating a middleware on top of TCP/IP. The initialization of the middleware takes care of setting up all parts.

```smalltalk
middleware := MpTcpMiddleware new.
```

## Exporting objects 

A middleware can export an object. That is making it available remotely.
Exporting an object answers a remote reference instance of `MpRemoteReference` 
Example
```smalltalk
someObject := ...
remoteReference := middleware export: someObject.
```
See `MpMiddlewareTest>>#testExportObject`.

## Proxy creation

Proxies can be forged by the middleware user from a remote reference. As in the following example :

```smalltalk
remoteReference := middlewareA export: self newValueHolder.
proxy := middlewareB objectAt: remoteReference.
```

Proxies are automatically created upon receiving a message which some argument is a remote reference, or upon receiving a remote reference as an answer to a sent message.

```smalltalk
objectFromA := …
remoteReferenceA := middlewareA export: objectFromA.
proxyAInB := middlewareB objectAt: remoteReferenceA.
objectFromB := …
proxyAInB doSomethingWith: objectFromB.
```

A proxy on `objectFromB` is created on the fly by `middlewareA` upon receiving themessage `doSomethingWith:`.


Each exported object is assigned an ID. By default, this is automated. But, IDs can be set by the middleware user upon exporting.
```smalltalk
middlewareA export: exportedObject id: #someUniqueID.
remoteReference := MpRemoteReference
                           address: middlewareA address
                           objectId: #someUniqueID.
proxy := middlewareB objectAt: remoteReference.
```

## Proxy Class and Species

We assume that **classes that have the same name are interoperable**. This asumption is useful for instnce, when it comes to testing equality.
So, when we send a proxy the `class` or the `species` message, we get a class from the local image (the one where the message was issued), if there is one with the same name as the actual remote class.

```smalltalk
objectFromA := #(1 2 3).
remoteReferenceA := middlewareA export: objectFromA.
proxyAInB := middlewareB objectAt: remoteReferenceA.
proxyAInB class. "--> actual Array class in B"
proxyAInB species. "--> actual Array class in B"
```
