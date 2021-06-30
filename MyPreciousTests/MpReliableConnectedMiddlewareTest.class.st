Class {
	#name : #MpReliableConnectedMiddlewareTest,
	#superclass : #MpMiddlewareTest,
	#category : #'MyPreciousTests-Connected'
}

{ #category : #testing }
MpReliableConnectedMiddlewareTest class >> isAbstract [
	^self == MpReliableConnectedMiddlewareTest 
]

{ #category : #tests }
MpReliableConnectedMiddlewareTest >> assertMiddleware: middleware persistsConnectionTo: address failMessage: aString [
	self waitWhile: [middleware transporter connections isEmpty].
	middleware transporter
		connectionAt: address 
		ifAbsent: [ self fail: aString ].

]

{ #category : #tests }
MpReliableConnectedMiddlewareTest >> middlewareClass [ 
	^MpConnectedMiddlewareForTest
]

{ #category : #tests }
MpReliableConnectedMiddlewareTest >> testAsynchrounousMessageSenderAndReceiverSaveConnections [
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
MpReliableConnectedMiddlewareTest >> testDeleteConnectionsUponStop [
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
		initialConnections do: [ : aConnection | self waitUntil: [aConnection isConnected] ]
	]
	
]

{ #category : #tests }
MpReliableConnectedMiddlewareTest >> testReconnectsIfOtherSideIsDisconnected [
	| valueHolderA remoteReferenceA connectionA|
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	"Ensure connection created"
	middlewareB send: #contents to: remoteReferenceA.
	connectionA := middlewareA transporter connections first.
	connectionA disconnect.
	self deny: connectionA isConnected.
	middlewareB send: #contents to: remoteReferenceA.
	"We on purpose access the collection of connections, since we don't know how reconnections are handled.
	There can be different implementations, i.e. connections can be fixed or recreated."
	self assert: middlewareA transporter connections size equals: 1.
	self assert: middlewareA transporter connections first isConnected

]

{ #category : #tests }
MpReliableConnectedMiddlewareTest >> testReconnectsIftherSideStopsReceiving [
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
MpReliableConnectedMiddlewareTest >> testRemoteMessageBasicSend [
	| valueHolderA remoteReferenceA message |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	message := MpSynchronousRemoteMessage new
		selector: #contents:;
		arguments: #(2);
		receiver: remoteReferenceA;
		senderAddress: middlewareB address;
		responseId: #anyID.
	middlewareB transporter basicSendMessage: message to: remoteReferenceA.
	self waitUntil: [valueHolderA contents = 2] onTimeout: 300 milliSeconds do: [ self fail: 'Assertion failed' ]
	
]

{ #category : #tests }
MpReliableConnectedMiddlewareTest >> testStopConnectionHandlingService [
	self allMiddleware do: [ : each |
		self assert: each transporter connectionService isRunning.
		each stop.
		self waitWhile: [each transporter connectionService isRunning].
	]
]

{ #category : #tests }
MpReliableConnectedMiddlewareTest >> testSynchrounousMessageSenderAndReceiverSaveConnections [
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
MpReliableConnectedMiddlewareTest >> testWaitsCreatingConnectionUntilOtherSideIsAvailable [
	| valueHolderA remoteReferenceA newValue |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	middlewareA stop.
	newValue := #somethingSpecial. 
	[middlewareB sendAsync: #contents: arguments: { newValue } to: remoteReferenceA] fork.
	[middlewareA start] fork.
	self waitUntil: [valueHolderA contents = newValue] timeout: 500 milliSeconds. 

]
