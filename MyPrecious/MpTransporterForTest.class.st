Class {
	#name : #MpTransporterForTest,
	#superclass : #MpTransporter,
	#instVars : [
		'sendQueue',
		'receiveQueue'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #communicating }
MpTransporterForTest >> incomingBytes [
	^receiveQueue next
]

{ #category : #initialization }
MpTransporterForTest >> initialize [
	super initialize.
	receiveQueue := SharedQueue new.
	
]

{ #category : #initialization }
MpTransporterForTest >> newReceptionService [
	^CcService repeat: [ self receiveBytes ]
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
MpTransporterForTest >> sendBytes: bytes [
	sendQueue nextPut: bytes
]

{ #category : #accessing }
MpTransporterForTest >> sendQueue [
	^ sendQueue
]

{ #category : #accessing }
MpTransporterForTest >> sendQueue: anObject [
	sendQueue := anObject
]
