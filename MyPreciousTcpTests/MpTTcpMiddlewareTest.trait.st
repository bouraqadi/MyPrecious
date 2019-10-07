Trait {
	#name : #MpTTcpMiddlewareTest,
	#category : #MyPreciousTcpTests
}

{ #category : #tests }
MpTTcpMiddlewareTest >> newMiddleware [ 
	^super newMiddleware
		port: NeTcpUsedPortsTracker freePortAtRandom;
		yourself
]
