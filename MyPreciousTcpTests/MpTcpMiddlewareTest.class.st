Class {
	#name : #MpTcpMiddlewareTest,
	#superclass : #MpConnectedMiddlewareTest,
	#category : #MyPreciousTcpTests
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