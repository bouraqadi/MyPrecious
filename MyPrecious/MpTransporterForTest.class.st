Class {
	#name : #MpTransporterForTest,
	#superclass : #MpAsynchronousTransporter,
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

{ #category : #receiving }
MpTransporterForTest >> readBytes [
	^receiveQueue next
]

{ #category : #accessing }
MpTransporterForTest >> receiveQueue [
	^ receiveQueue
]

{ #category : #sending }
MpTransporterForTest >> registry [
	^self middleware registry
]

{ #category : #sending }
MpTransporterForTest >> sendBytes: bytes toAddress: address [
	| targetTransporter |
	targetTransporter := self registry at: address.
	targetTransporter receiveQueue nextPut: bytes

]
