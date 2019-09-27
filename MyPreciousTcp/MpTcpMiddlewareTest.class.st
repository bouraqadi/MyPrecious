Class {
	#name : #MpTcpMiddlewareTest,
	#superclass : #MpConnectedTransportMiddlewareTest,
	#category : #MyPreciousTcp
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
