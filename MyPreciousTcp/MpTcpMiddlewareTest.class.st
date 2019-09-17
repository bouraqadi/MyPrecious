Class {
	#name : #MpTcpMiddlewareTest,
	#superclass : #MpMiddlewareTestOLD,
	#traits : 'MpTMiddlewareDebugSupportOLD',
	#classTraits : 'MpTMiddlewareDebugSupportOLD classTrait',
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
