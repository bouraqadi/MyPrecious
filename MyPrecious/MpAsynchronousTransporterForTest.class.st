Class {
	#name : #MpAsynchronousTransporterForTest,
	#superclass : #MpAsynchronousTransporterOLD,
	#instVars : [
		'receiveQueue'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #receiving }
MpAsynchronousTransporterForTest >> receiveBytes [
	self receiveBytes: receiveQueue next
]

{ #category : #accessing }
MpAsynchronousTransporterForTest >> receiveQueue: anObject [
	receiveQueue := anObject
]

{ #category : #communicating }
MpAsynchronousTransporterForTest >> registry [
	^self middleware registry
]

{ #category : #communicating }
MpAsynchronousTransporterForTest >> sendBytes: bytes toAddress: address [
	| otherMiddleware |
	otherMiddleware := self registry at: address.
	otherMiddleware transporter receiveQueue nextPut: bytes
]
