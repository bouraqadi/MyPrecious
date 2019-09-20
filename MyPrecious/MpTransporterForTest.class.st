Class {
	#name : #MpTransporterForTest,
	#superclass : #MpTransporter,
	#instVars : [
		'receiveQueue'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #initialization }
MpTransporterForTest >> initialize [
	super initialize.
	receiveQueue := SharedQueue new.
	
]

{ #category : #initialization }
MpTransporterForTest >> newReceptionService [
	^CcService repeat: [ self receiveBytes ]
]

{ #category : #receiving }
MpTransporterForTest >> receiveBytes [
	self receiveBytes: receiveQueue next
]

{ #category : #accessing }
MpTransporterForTest >> receiveQueue [
	^ receiveQueue
]

{ #category : #accessing }
MpTransporterForTest >> receiveQueue: anObject [
	receiveQueue := anObject
]

{ #category : #communicating }
MpTransporterForTest >> registry [
	^self middleware registry
]

{ #category : #communicating }
MpTransporterForTest >> sendBytes: bytes to: address [
	| otherMiddleware |
	otherMiddleware := self registry at: address.
	otherMiddleware transporter receiveQueue nextPut: bytes
]
