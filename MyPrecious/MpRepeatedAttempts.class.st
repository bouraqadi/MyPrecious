Class {
	#name : #MpRepeatedAttempts,
	#superclass : #MpReliabilityStrategy,
	#instVars : [
		'maxAttemptsCount',
		'durationBetweenAttempts'
	],
	#category : #'MyPrecious-Connected'
}

{ #category : #initialization }
MpRepeatedAttempts >> defaultDurationBetweenAttempts [
	^100 milliSeconds
]

{ #category : #initialization }
MpRepeatedAttempts >> defaultMaxAttemptsCount [
	^5
]

{ #category : #attempting }
MpRepeatedAttempts >> durationBetweenAttempts [
	^ durationBetweenAttempts
]

{ #category : #attempting }
MpRepeatedAttempts >> durationBetweenAttempts: anObject [
	durationBetweenAttempts := anObject
]

{ #category : #sending }
MpRepeatedAttempts >> handleException: exception onAsynchronousMessage: remoteMessage to: targetRemoteReference [
	self subclassResponsibility
]

{ #category : #sending }
MpRepeatedAttempts >> handleException: exception onSynchronousMessage: remoteMessage to: targetRemoteReference [
	self subclassResponsibility
]

{ #category : #initialization }
MpRepeatedAttempts >> initialize [
	super initialize.
	self maxAttemptsCount: self defaultMaxAttemptsCount.
	self durationBetweenAttempts: self defaultDurationBetweenAttempts
]

{ #category : #attempting }
MpRepeatedAttempts >> maxAttemptsCount [
	^maxAttemptsCount
]

{ #category : #attempting }
MpRepeatedAttempts >> maxAttemptsCount: anObject [
	maxAttemptsCount := anObject
]

{ #category : #attempting }
MpRepeatedAttempts >> repeat: actionBlock onException: exceptionClass do: exceptionHandlerBlock onFail: failBlock [
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
MpRepeatedAttempts >> sendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	self 
		repeat: [ self basicSendAsynchronousMessage: remoteMessage to: targetRemoteReference ]
		onException: MpCouldNotDeliverMessageError, MpConnectionFailed
		do: [: exception | self handleException: exception onAsynchronousMessage: remoteMessage to: targetRemoteReference]
		onFail: [ : exception | exception signal ]
]

{ #category : #sending }
MpRepeatedAttempts >> sendSynchronousMessage: remoteMessage to: targetRemoteReference [
	self 
		repeat: [ ^self basicSendSynchronousMessage: remoteMessage to: targetRemoteReference ]
		onException: MpCouldNotDeliverMessageError, MpConnectionFailed, MpRemoteMessageResultTimeout
		do: [: exception | self handleException: exception onSynchronousMessage: remoteMessage to: targetRemoteReference]
		onFail: [ : exception | exception signal ]
]
