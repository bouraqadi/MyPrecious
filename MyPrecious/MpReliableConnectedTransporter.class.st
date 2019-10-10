Class {
	#name : #MpReliableConnectedTransporter,
	#superclass : #MpConnectedTransporter,
	#instVars : [
		'maxAttemptsCount',
		'durationBetweenAttempts'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #connecting }
MpReliableConnectedTransporter >> connectionTo: targetRemoteReference [
	| connection |
	connection := super connectionTo: targetRemoteReference.
	connection isConnected ifTrue: [ ^connection ].
	self 
		repeat: [ connection connect ] 
		until: [connection isConnected]
		onFailDo: [MpConnectionFailed signal].
	^connection
]

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

{ #category : #connecting }
MpReliableConnectedTransporter >> newConnectionTo: targetRemoteReference [
	| newConnection |
	self 
		repeat: [newConnection := super newConnectionTo: targetRemoteReference] 
		until: [newConnection notNil and: [newConnection isConnected]]
		onFailDo: [MpConnectionFailed signal].
	^newConnection
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
