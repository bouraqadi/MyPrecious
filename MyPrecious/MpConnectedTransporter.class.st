Class {
	#name : #MpConnectedTransporter,
	#superclass : #MpTransporter,
	#instVars : [
		'connectionsDict',
		'connectionService',
		'connectionsLock'
	],
	#category : #'MyPrecious-Connected'
}

{ #category : #connecting }
MpConnectedTransporter >> acceptConnectionWith: anObject [
	^ self newConnection
		acceptConnectionWith: anObject;
		startReceiving;
		yourself
]

{ #category : #sending }
MpConnectedTransporter >> basicSendMessage: remoteMessage to: targetRemoteReference [
	[| connection |
	connection := self connectionTo: targetRemoteReference.
	connection sendObject: remoteMessage.
	^ connection
	]
		on: Error
		do: [ :ex | self signalSendingRemoteMessage: remoteMessage raisedException: ex ]
]

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
	targetRemoteReference ifNil: [MpConnectionFailed signal].
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
	^ self newConnection
		otherSideAddress: targetRemoteReference address;
		connect;
		startReceiving; 
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
MpConnectedTransporter >> saveConnection: aConnection toAddress: address [
	connectionsLock critical: [connectionsDict at: address put: aConnection]
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
