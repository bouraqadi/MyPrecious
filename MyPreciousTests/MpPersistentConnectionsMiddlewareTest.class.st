Class {
	#name : #MpPersistentConnectionsMiddlewareTest,
	#superclass : #MpConnectedMiddlewareTest,
	#category : #'MyPreciousTests-Connected'
}

{ #category : #tests }
MpPersistentConnectionsMiddlewareTest >> assertMiddleware: middleware persistsConnectionTo: address failMessage: aString [
	| connectionsDict |
	connectionsDict := middleware transporter connectionsDict.
	self waitWhile: [connectionsDict isEmpty].
	connectionsDict
		at: address 
		ifAbsent: [ self fail: aString ].

]

{ #category : #tests }
MpPersistentConnectionsMiddlewareTest >> middlewareClass [ 
	^MpPersistentConnectionsMiddlewareForTest
]

{ #category : #tests }
MpPersistentConnectionsMiddlewareTest >> testAsynchrounousMessageSenderAndReceiverSaveConnections [
	| valueHolderA remoteReferenceA |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	middlewareB sendAsync: #contents to: remoteReferenceA.
	self 
		assertMiddleware: middlewareB 
		persistsConnectionTo: middlewareA address 
		failMessage: 'Connection NOT persisted in sender'.
	self 
		assertMiddleware: middlewareA 
		persistsConnectionTo: middlewareB address 
		failMessage: 'Connection NOT persisted in receiver'.

]

{ #category : #tests }
MpPersistentConnectionsMiddlewareTest >> testSynchrounousMessageSenderAndReceiverSaveConnections [
	| valueHolderA remoteReferenceA |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	middlewareB send: #contents to: remoteReferenceA.
	self 
		assertMiddleware: middlewareB 
		persistsConnectionTo: middlewareA address 
		failMessage: 'Connection NOT persisted in sender'.
	self 
		assertMiddleware: middlewareA 
		persistsConnectionTo: middlewareB address 
		failMessage: 'Connection NOT persisted in receiver'.

]
