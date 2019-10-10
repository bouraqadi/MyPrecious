Class {
	#name : #MpConnectedMiddlewareTest,
	#superclass : #MpMiddlewareTest,
	#category : #'MyPreciousTests-Connected'
}

{ #category : #tests }
MpConnectedMiddlewareTest >> assertMiddleware: middleware persistsConnectionTo: address failMessage: aString [
	self waitWhile: [middleware transporter connections isEmpty].
	middleware transporter
		connectionAt: address 
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
MpConnectedMiddlewareTest >> testDeleteConnectionsUponStop [
	| valueHolderA remoteReferenceA initialConnections |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	middlewareB send: #contents to: remoteReferenceA.
	middlewareC send: #contents to: remoteReferenceA.
	self allMiddleware do: [ : aMiddleware |
		initialConnections := aMiddleware transporter connections.
		initialConnections do: [ : aConnection | self assert: aConnection isConnected ].
		aMiddleware stop.
		self assert: aMiddleware transporter connections isEmpty.
		initialConnections do: [ : aConnection | self deny: aConnection isConnected ]
	]
	
]

{ #category : #tests }
MpConnectedMiddlewareTest >> testReconnectsIfOtherSideIsDisconnected [
	| valueHolderA remoteReferenceA connectionA|
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	"Ensure connection created"
	middlewareB send: #contents to: remoteReferenceA.
	connectionA := middlewareA transporter connections first.
	connectionA disconnect.
	self deny: connectionA isConnected.
	middlewareB send: #contents to: remoteReferenceA.
	self assert: middlewareA transporter connections size equals: 1.
	self assert: middlewareA transporter connections first isConnected

]

{ #category : #tests }
MpConnectedMiddlewareTest >> testReconnectsIftherSideStopsReceiving [
	| valueHolderA remoteReferenceA connectionA newValue |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	"Ensure connection created"
	middlewareB send: #contents to: remoteReferenceA.
	connectionA := middlewareA transporter connections first.
	connectionA stopReceiving.
	newValue := #somethingSpecial. 
	middlewareB send: #contents: arguments: { newValue } to: remoteReferenceA.
	self assert: valueHolderA contents equals: newValue

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
MpConnectedMiddlewareTest >> testStopConnectionHandlingService [
	self allMiddleware do: [ : each |
		self assert: each transporter connectionService isStarted.
		each stop.
		self deny: each transporter connectionService isStarted.
	]
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

{ #category : #tests }
MpConnectedMiddlewareTest >> testWaitsCreatingConnectionUntilOtherSideIsAvailable [
	| valueHolderA remoteReferenceA newValue sendSemaphore |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	middlewareA stop.
	newValue := #somethingSpecial. 
	sendSemaphore := Semaphore new.
	[
		middlewareB sendAsync: #contents: arguments: { newValue } to: remoteReferenceA.
		sendSemaphore signal] fork.
	[middlewareA start] fork.
	self deny: (sendSemaphore wait: 500 milliSeconds).
	self assert: valueHolderA contents equals: newValue

]
