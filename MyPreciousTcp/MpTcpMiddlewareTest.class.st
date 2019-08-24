Class {
	#name : #MpTcpMiddlewareTest,
	#superclass : #MpMiddlwareTest,
	#category : #MyPreciousTcp
}

{ #category : #tests }
MpTcpMiddlewareTest >> middlewareClass [
	^ MpTcpMiddleware
]

{ #category : #tests }
MpTcpMiddlewareTest >> setUp [
	super setUp.
	self allMiddleware do: [ : each |
		each 
			port: NeTcpUsedPortsTracker freePortAtRandom;
			start ]
]

{ #category : #tests }
MpTcpMiddlewareTest >> tearDown [
	super tearDown.
	self allMiddleware do: [ : each | each stop]
]
