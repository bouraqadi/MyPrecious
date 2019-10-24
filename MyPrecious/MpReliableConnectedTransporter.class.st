Class {
	#name : #MpReliableConnectedTransporter,
	#superclass : #MpConnectedTransporter,
	#instVars : [
		'reliabilityStrategy'
	],
	#category : #'MyPrecious-Connected'
}

{ #category : #sending }
MpReliableConnectedTransporter >> basicSendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	super sendAsynchronousMessage: remoteMessage to: targetRemoteReference

]

{ #category : #sending }
MpReliableConnectedTransporter >> basicSendSynchronousMessage: remoteMessage to: targetRemoteReference [
	^super sendSynchronousMessage: remoteMessage to: targetRemoteReference

]

{ #category : #initialization }
MpReliableConnectedTransporter >> defaultReliabilityStrategyClass [
	^MpRecreateConnection
]

{ #category : #initialization }
MpReliableConnectedTransporter >> initialize [
	super initialize.
	self reliabilityStrategy: self defaultReliabilityStrategyClass new.

]

{ #category : #accessing }
MpReliableConnectedTransporter >> reliabilityStrategy [
	^ reliabilityStrategy
]

{ #category : #accessing }
MpReliableConnectedTransporter >> reliabilityStrategy: aMpReliabilityStrategy [
	reliabilityStrategy := aMpReliabilityStrategy.
	reliabilityStrategy transporter: self
]

{ #category : #connecting }
MpReliableConnectedTransporter >> removeConnectionTo: remoteReference [
	remoteReference ifNil: [ ^self ].
	^connectionsLock critical: [connectionsDict 
		removeKey: remoteReference address
		ifAbsent: nil "ignore"]
]

{ #category : #sending }
MpReliableConnectedTransporter >> sendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	^self reliabilityStrategy
		sendAsynchronousMessage: remoteMessage 
		to: targetRemoteReference

]

{ #category : #sending }
MpReliableConnectedTransporter >> sendSynchronousMessage: remoteMessage to: targetRemoteReference [
	^self reliabilityStrategy
		sendSynchronousMessage: remoteMessage 
		to: targetRemoteReference

]
