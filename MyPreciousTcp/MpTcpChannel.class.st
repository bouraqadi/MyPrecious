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
MpTcpChannel >> flush [
	self socketStream flush
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
	| bytesCountSize bytesCount |
	bytesCountSize := (self next: self byteCountArraySize) asInteger.
	bytesCount := (self next: bytesCountSize) asInteger.
	^self next: bytesCount.

]

{ #category : #communicating }
MpTcpChannel >> receptionStep [
	"Upon timeout wait a bit and continue"
	[ super receptionStep ] 
		on: ConnectionTimedOut 
		do: [ : ex | ]
]

{ #category : #communicating }
MpTcpChannel >> sendBytes: bytes [
	| bytesCountArray bytesCountSizeArray|
	bytesCountArray := bytes size asByteArray.
	bytesCountSizeArray := bytesCountArray size asByteArrayOfSize: self byteCountArraySize.
	self
		nextPutAll: bytesCountSizeArray;
		nextPutAll: bytesCountArray;
		nextPutAll: bytes;
		flush.

]

{ #category : #accessing }
MpTcpChannel >> socketStream [
	^socketStream
]

{ #category : #accessing }
MpTcpChannel >> socketStream: aSocketStream [
	socketStream := aSocketStream
]
