Class {
	#name : #MpUnconnectedTransporterForTest,
	#superclass : #MpUnconnectedTransporter,
	#instVars : [
		'receiveQueue'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #initialization }
MpUnconnectedTransporterForTest >> initialize [
	super initialize.
	receiveQueue := SharedQueue new.
	
]

{ #category : #receiving }
MpUnconnectedTransporterForTest >> readBytes [
	^receiveQueue next
]

{ #category : #accessing }
MpUnconnectedTransporterForTest >> receiveQueue [
	^ receiveQueue
]

{ #category : #sending }
MpUnconnectedTransporterForTest >> registry [
	^self middleware registry
]

{ #category : #sending }
MpUnconnectedTransporterForTest >> sendBytes: bytes toAddress: address [
	| targetTransporter |
	targetTransporter := self registry at: address.
	targetTransporter receiveQueue nextPut: bytes

]
