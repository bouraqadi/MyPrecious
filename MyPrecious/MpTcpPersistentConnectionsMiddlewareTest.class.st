Class {
	#name : #MpTcpPersistentConnectionsMiddlewareTest,
	#superclass : #MpPersistentConnectionsMiddlewareTest,
	#traits : 'MpTTcpMiddlewareTest',
	#classTraits : 'MpTTcpMiddlewareTest classTrait',
	#category : #'MyPrecious-ToDelete'
}

{ #category : #tests }
MpTcpPersistentConnectionsMiddlewareTest >> middlewareClass [
	^ MpTcpPersistentConnectionsMiddleware
]
