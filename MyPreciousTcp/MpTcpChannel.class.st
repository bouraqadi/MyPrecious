Class {
	#name : #MpTcpChannel,
	#superclass : #MpChannel,
	#instVars : [
		'socketStream'
	],
	#category : #MyPreciousTcp
}

{ #category : #communicating }
MpTcpChannel >> byteCountArraySize [
	^4
]

{ #category : #communicating }
MpTcpChannel >> communicateVia: aSocketStream [
	socketStream := aSocketStream.
	[socketStream isConnected] whileTrue: [ self receiveBytes ]
]

{ #category : #communicating }
MpTcpChannel >> next: numberOfBytes [
	^self socketStream next: numberOfBytes
]

{ #category : #communicating }
MpTcpChannel >> nextPutAll: bytes [
	^self socketStream nextPutAll: bytes
]

{ #category : #communicating }
MpTcpChannel >> receiveBytes [
	| bytesCountSize bytesCount bytes |
	bytesCountSize := (self next: self byteCountArraySize) asInteger.
	bytesCount := (self next: bytesCountSize) asInteger.
	bytes := self next: bytesCount.
	self receiveBytes: bytes
]

{ #category : #communicating }
MpTcpChannel >> sendBytes: bytes [
	| bytesCountArray bytesCountSizeArray|
	bytesCountArray := bytes size asByteArray.
	bytesCountSizeArray := bytesCountArray size asByteArrayOfSize: self byteCountArraySize.
	self
		nextPutAll: bytesCountSizeArray;
		nextPutAll: bytesCountArray;
		nextPutAll: bytes
]

{ #category : #accessing }
MpTcpChannel >> socketStream [
	^socketStream
]

{ #category : #accessing }
MpTcpChannel >> socketStream: aSocketStream [
	socketStream := aSocketStream
]
