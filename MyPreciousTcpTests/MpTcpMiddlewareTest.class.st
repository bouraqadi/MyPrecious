Class {
	#name : #MpTcpMiddlewareTest,
	#superclass : #MpConnectedMiddlewareTest,
	#traits : 'MpTTcpMiddlewareTest',
	#classTraits : 'MpTTcpMiddlewareTest classTrait',
	#category : #MyPreciousTcpTests
}

{ #category : #tests }
MpTcpMiddlewareTest >> middlewareClass [
	^ MpTcpMiddleware
]
