Class {
	#name : #MpTcpMiddlewareTest,
	#superclass : #MpReliableConnectedMiddlewareTest,
	#category : #MyPreciousNetTests
}

{ #category : #tests }
MpTcpMiddlewareTest >> middlewareClass [
	^ MpTcpMiddleware
]

{ #category : #tests }
MpTcpMiddlewareTest >> newMiddleware [ 
	^super newMiddleware
		port: NeTcpUsedPortsTracker freePortAtRandom;
		yourself
]
