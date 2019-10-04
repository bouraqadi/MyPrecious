Class {
	#name : #MpPersistentConnectionsMiddlewareTest,
	#superclass : #MpConnectedMiddlewareTest,
	#category : #'MyPreciousTests-Connected'
}

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
	middlewareB transporter connectionsDict 
		at: middlewareA address 
		ifAbsent: [ self fail: 'Connection NOT persisted in sender' ].
	middlewareA transporter connectionsDict 
		at: middlewareB address 
		ifAbsent: [ self fail: 'Connection NOT persisted in receiver' ].

]

{ #category : #tests }
MpPersistentConnectionsMiddlewareTest >> testSynchrounousMessageSenderAndReceiverSaveConnections [
	| valueHolderA remoteReferenceA |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	middlewareB send: #contents to: remoteReferenceA.
	middlewareB transporter connectionsDict 
		at: middlewareA address 
		ifAbsent: [ self fail: 'Connection NOT persisted in sender' ].
	middlewareA transporter connectionsDict 
		at: middlewareB address 
		ifAbsent: [ self fail: 'Connection NOT persisted in receiver' ].

]
