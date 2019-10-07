Class {
	#name : #MpTcpPersistentConnectionsMiddlewareTest,
	#superclass : #MpPersistentConnectionsMiddlewareTest,
	#traits : 'MpTTcpMiddlewareTest',
	#classTraits : 'MpTTcpMiddlewareTest classTrait',
	#category : #MyPreciousTcpTests
}

{ #category : #tests }
MpTcpPersistentConnectionsMiddlewareTest >> middlewareClass [
	^ MpTcpPersistentConnectionsMiddleware
]
