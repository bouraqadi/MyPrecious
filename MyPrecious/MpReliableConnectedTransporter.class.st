Class {
	#name : #MpReliableConnectedTransporter,
	#superclass : #MpConnectedTransporter,
	#instVars : [
		'maxAttemptsCount',
		'durationBetweenAttempts'
	],
	#category : #'MyPrecious-Kernel'
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
	| attemptsLeft done capturedException |
	attemptsLeft :=  self maxAttemptsCount.
	done := false.
	[done] whileFalse: [
			capturedException := nil.
			actionBlock on: exceptionClass do: [: exception | capturedException := exception].
			capturedException 
				ifNil: [done := true]
				ifNotNil: [
					attemptsLeft := attemptsLeft - 1.
					attemptsLeft = 0 ifTrue: [failBlock cull: capturedException].
					exceptionHandlerBlock cull: capturedException.
					self durationBetweenAttempts wait].
			].

]

{ #category : #attempting }
MpReliableConnectedTransporter >> repeat: actionBlock until: conditionBlock onFailDo: failBlock [
	self maxAttemptsCount timesRepeat: [
		actionBlock on: Exception do: ["ignore"].
		conditionBlock value ifTrue: [ ^self ].
		self durationBetweenAttempts wait.
	].
	failBlock value

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
