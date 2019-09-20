Class {
	#name : #MpTcpTransporter,
	#superclass : #MpTransporter,
	#category : #MyPreciousTcp
}

{ #category : #accessing }
MpTcpTransporter >> byteCountArraySize [
	^4
]

{ #category : #initialization }
MpTcpTransporter >> newReceptionService [
	^self serverClass new
		withCommunicationStreamDo: [ : stream | 
			self receiveBytesFromStream: stream ];
		yourself
]

{ #category : #accessing }
MpTcpTransporter >> port: integer [
	receptionService port: integer.

]

{ #category : #receiving }
MpTcpTransporter >> receiveBytesFromStream: stream [
	| bytesCountSize bytesCount |
	[
		bytesCountSize := (stream next: self byteCountArraySize) asInteger.
		bytesCount := (stream next: bytesCountSize) asInteger.
		self receiveBytes: (stream next: bytesCount)
	] ensure: [ 
		stream close ]

]

{ #category : #sending }
MpTcpTransporter >> sendBytes: bytes to: address [
	| socketStream bytesCountArray bytesCountSizeArray |
	socketStream := ZdcSocketStream openConnectionToHost: address ip port: address port.
	bytesCountArray := bytes size asByteArray.
	bytesCountSizeArray := bytesCountArray size asByteArrayOfSize: self byteCountArraySize.
	[socketStream
		nextPutAll: bytesCountSizeArray;
		nextPutAll: bytesCountArray;
		nextPutAll: bytes
	] ensure: [socketStream close].
	
]

{ #category : #initialization }
MpTcpTransporter >> serverClass [
	^NeTcpServer 
]
