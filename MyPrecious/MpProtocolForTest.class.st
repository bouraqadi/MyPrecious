Class {
	#name : #MpProtocolForTest,
	#superclass : #MpProtocol,
	#category : #'MyPrecious-Tests'
}

{ #category : #communicating }
MpProtocolForTest >> sendBytes: bytes [
	self targetProtocol receiveBytes: bytes
]

{ #category : #communicating }
MpProtocolForTest >> targetProtocol [
	^self channel targetChannel protocol
]
