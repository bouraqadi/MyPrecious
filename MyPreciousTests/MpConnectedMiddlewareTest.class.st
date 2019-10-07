Class {
	#name : #MpConnectedMiddlewareTest,
	#superclass : #MpMiddlewareTest,
	#category : #'MyPreciousTests-Connected'
}

{ #category : #tests }
MpConnectedMiddlewareTest >> assertMiddleware: middleware persistsConnectionTo: address failMessage: aString [
	| connectionsDict |
	connectionsDict := middleware transporter connectionsDict.
	self waitWhile: [connectionsDict isEmpty].
	connectionsDict
		at: address 
		ifAbsent: [ self fail: aString ].

]

{ #category : #tests }
MpConnectedMiddlewareTest >> middlewareClass [ 
	^MpConnectedMiddlewareForTest
]

{ #category : #tests }
MpConnectedMiddlewareTest >> testAsynchrounousMessageSenderAndReceiverSaveConnections [
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
MpConnectedMiddlewareTest >> testRemoteMessageBasicSend [
	| valueHolderA remoteReferenceA message connection |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	message := MpSynchronousRemoteMessage new
		selector: #contents:;
		arguments: #(2);
		receiver: remoteReferenceA;
		senderAddress: middlewareB address;
		responseId: #anyID.
	connection := middlewareB transporter connectionTo: remoteReferenceA.
	connection sendObject: message.
	self waitUntil: [valueHolderA contents = 2] onTimeout: 300 milliSeconds do: [ self fail: 'Assertion failed' ]
	
]

{ #category : #tests }
MpConnectedMiddlewareTest >> testSynchrounousMessageSenderAndReceiverSaveConnections [
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
