Class {
	#name : #MpConnectedTransporter,
	#superclass : #MpTransporter,
	#instVars : [
		'connectionHandlingService'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #connecting }
MpConnectedTransporter >> connectTo: targetRemoteReference [
	^self newConnection
		connectTo: targetRemoteReference;
		yourself
		
]

{ #category : #connecting }
MpConnectedTransporter >> connectionClass [
	self subclassResponsibility
]

{ #category : #connecting }
MpConnectedTransporter >> connectionHandlingService [
	^ connectionHandlingService
]

{ #category : #initialization }
MpConnectedTransporter >> initialize [
	super initialize.
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

{ #category : #initialization }
MpConnectedTransporter >> receptionServicePriority: anInteger [
	connectionHandlingService priority: anInteger
]

{ #category : #sending }
MpConnectedTransporter >> sendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	| connection |
	[
		connection := self connectTo: targetRemoteReference.
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
	
]
