Class {
	#name : #MpConnectedTransporter,
	#superclass : #MpTransporter,
	#instVars : [
		'connectionsDict',
		'connectionService',
		'connectionsLock'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #connecting }
MpConnectedTransporter >> connectionAt: address ifAbsent: aBlock [
	^connectionsLock critical: [connectionsDict 
		at: address
		ifAbsent: aBlock]
]

{ #category : #connecting }
MpConnectedTransporter >> connectionClass [
	self subclassResponsibility
]

{ #category : #connecting }
MpConnectedTransporter >> connectionService [
	^ connectionService
]

{ #category : #connecting }
MpConnectedTransporter >> connectionTo: targetRemoteReference [
	^connectionsLock critical: [
		connectionsDict 
			at: targetRemoteReference address
			ifAbsentPut: [ self newConnectionTo: targetRemoteReference ]]
]

{ #category : #accessing }
MpConnectedTransporter >> connections [
	^connectionsLock critical: [connectionsDict values]
]

{ #category : #initialization }
MpConnectedTransporter >> initialize [
	super initialize.
	connectionsLock := Mutex new.
	self resetConnectionsDict.
	connectionService := self newConnectionHandlingService
]

{ #category : #activity }
MpConnectedTransporter >> isStarted [
	^self connectionService isStarted.
	
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
	^connectionService priority
]

{ #category : #initialization }
MpConnectedTransporter >> receptionPriority: anInteger [
	connectionService priority: anInteger
]

{ #category : #initialization }
MpConnectedTransporter >> resetConnectionsDict [
	connectionsLock critical: [connectionsDict := Dictionary new]
]

{ #category : #connecting }
MpConnectedTransporter >> saveConnection: aConnection to: address [
	connectionsLock critical: [connectionsDict at: address put: aConnection]
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
	self connectionService start
]

{ #category : #activity }
MpConnectedTransporter >> stop [
	self connectionService stop.
	self connections do: #stopReceiving.
	self resetConnectionsDict.

]
