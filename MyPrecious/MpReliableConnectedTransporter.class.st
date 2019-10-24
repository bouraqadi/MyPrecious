Class {
	#name : #MpReliableConnectedTransporter,
	#superclass : #MpConnectedTransporter,
	#instVars : [
		'maxAttemptsCount',
		'durationBetweenAttempts'
	],
	#category : #'MyPrecious-Connected'
}

{ #category : #initialization }
MpReliableConnectedTransporter >> defaultDurationBetweenAttempts [
	^100 milliSeconds
]

{ #category : #initialization }
MpReliableConnectedTransporter >> defaultMaxAttemptsCount [
	^5
]

{ #category : #attempting }
MpReliableConnectedTransporter >> durationBetweenAttempts [
	^ durationBetweenAttempts
]

{ #category : #attempting }
MpReliableConnectedTransporter >> durationBetweenAttempts: anObject [
	durationBetweenAttempts := anObject
]

{ #category : #initialization }
MpReliableConnectedTransporter >> initialize [
	super initialize.
	self maxAttemptsCount: self defaultMaxAttemptsCount.
	self durationBetweenAttempts: self defaultDurationBetweenAttempts
]

{ #category : #attempting }
MpReliableConnectedTransporter >> maxAttemptsCount [
	^maxAttemptsCount
]

{ #category : #attempting }
MpReliableConnectedTransporter >> maxAttemptsCount: anObject [
	maxAttemptsCount := anObject
]

{ #category : #sending }
MpReliableConnectedTransporter >> reconectTo: targetRemoteReference [
	(self connectionTo: targetRemoteReference) reset
]

{ #category : #attempting }
MpReliableConnectedTransporter >> repeat: actionBlock onException: exceptionClass do: exceptionHandlerBlock onFail: failBlock [
	| capturedException |
	self maxAttemptsCount timesRepeat: [
		capturedException := nil.
		actionBlock on: exceptionClass do: [: exception | capturedException := exception].
		capturedException ifNil: [^self].
		exceptionHandlerBlock cull: capturedException.
		self durationBetweenAttempts wait.
	].
	failBlock cull: capturedException
]

{ #category : #sending }
MpReliableConnectedTransporter >> sendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	self 
		repeat: [ super sendAsynchronousMessage: remoteMessage to: targetRemoteReference ]
		onException: MpCouldNotDeliverMessageError, MpConnectionFailed
		do: [ self reconectTo: targetRemoteReference ]
		onFail: [ : exception | exception signal ]
]

{ #category : #sending }
MpReliableConnectedTransporter >> sendSynchronousMessage: remoteMessage to: targetRemoteReference [
	self 
		repeat: [ ^super sendSynchronousMessage: remoteMessage to: targetRemoteReference ]
		onException: MpCouldNotDeliverMessageError, MpConnectionFailed, MpRemoteMessageResultTimeout
		do: [ self reconectTo: targetRemoteReference ]
		onFail: [ : exception | exception signal ]
]
