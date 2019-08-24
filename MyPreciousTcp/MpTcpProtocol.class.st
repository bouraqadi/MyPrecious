Class {
	#name : #MpTcpProtocol,
	#superclass : #MpProtocol,
	#category : #MyPreciousTcp
}

{ #category : #communicating }
MpTcpProtocol >> byteCountArraySize [
	^4
]

{ #category : #communicating }
MpTcpProtocol >> next: numberOfBytes [
	^self socketStream next: numberOfBytes
]

{ #category : #communicating }
MpTcpProtocol >> nextPutAll: bytes [
	^self socketStream nextPutAll: bytes
]

{ #category : #communicating }
MpTcpProtocol >> receiveBytes [
	| bytesCountSize bytesCount bytes |
	bytesCountSize := (self next: self byteCountArraySize) asInteger.
	bytesCount := (self next: bytesCountSize) asInteger.
	bytes := self next: bytesCount.
	self receiveBytes: bytes
]

{ #category : #communicating }
MpTcpProtocol >> sendBytes: bytes [
	| bytesCountArray bytesCountSizeArray|
	bytesCountArray := bytes size asByteArray.
	bytesCountSizeArray := bytesCountArray size asByteArrayOfSize: self byteCountArraySize.
	self
		nextPutAll: bytesCountSizeArray;
		nextPutAll: bytesCountArray;
		nextPutAll: bytes
]

{ #category : #accessing }
MpTcpProtocol >> socketStream [
	^self channel socketStream
]
