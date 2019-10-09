Class {
	#name : #MpConnectedTransporter,
	#superclass : #MpTransporter,
	#instVars : [
		'connectionHandlingService',
		'connectionsDict'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #connecting }
MpConnectedTransporter >> connectionClass [
	self subclassResponsibility
]

{ #category : #connecting }
MpConnectedTransporter >> connectionHandlingService [
	^ connectionHandlingService
]

{ #category : #connecting }
MpConnectedTransporter >> connectionTo: targetRemoteReference [
	^connectionsDict 
		at: targetRemoteReference address
		ifAbsentPut: [ self newConnectionTo: targetRemoteReference ]
]

{ #category : #accessing }
MpConnectedTransporter >> connections [
	^self connectionsDict values
]

{ #category : #accessing }
MpConnectedTransporter >> connectionsDict [
	^connectionsDict
]

{ #category : #initialization }
MpConnectedTransporter >> initialize [
	super initialize.
	self resetConnectionsDict.
	connectionHandlingService := self newConnectionHandlingService
]

{ #category : #activity }
MpConnectedTransporter >> isStarted [
	^self connectionHandlingService isStarted.
	
]

{ #category : #connecting }
MpConnectedTransporter >> newConnection [
	^self connectionClass new
		transporter: self;
		yourself
]

{ #category : #initialization }
MpConnectedTransporter >> newConnectionHandlingService [
	self subclassResponsibility
]

{ #category : #connecting }
MpConnectedTransporter >> newConnectionTo: targetRemoteReference [
	| metaMessage |
	metaMessage := MpSaveConnectionMetaMessage new.
	metaMessage otherSideAddress: self address.
	^self newConnection
		connectTo: targetRemoteReference;
		startReceiving;
		sendObject: metaMessage
		yourself
]

{ #category : #initialization }
MpConnectedTransporter >> receptionPriority [
	^connectionHandlingService priority
]

{ #category : #initialization }
MpConnectedTransporter >> receptionPriority: anInteger [
	connectionHandlingService priority: anInteger
]

{ #category : #initialization }
MpConnectedTransporter >> resetConnectionsDict [
	connectionsDict := Dictionary new
]

{ #category : #connecting }
MpConnectedTransporter >> saveConnection: aConnection to: address [
	connectionsDict at: address put: aConnection
]

{ #category : #sending }
MpConnectedTransporter >> sendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	| connection |
	[
		connection := self connectionTo: targetRemoteReference.
		connection sendObject: remoteMessage.
		^ connection	]
	on: Error
	do: [ :ex | self signalSendingRemoteMessage: remoteMessage raisedException: ex ]
]

{ #category : #activity }
MpConnectedTransporter >> start [
	self connectionHandlingService start
]

{ #category : #activity }
MpConnectedTransporter >> stop [
	self connectionHandlingService stop.
	self connections do: #stopReceiving.
	self resetConnectionsDict.

]
