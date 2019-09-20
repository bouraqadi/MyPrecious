Class {
	#name : #MpTcpTransporterOLD,
	#superclass : #MpTransporter,
	#category : #MyPreciousTcp
}

{ #category : #accessing }
MpTcpTransporterOLD >> byteCountArraySize [
	^4
]

{ #category : #receiving }
MpTcpTransporterOLD >> receiveBytesFromStream: stream [
	| bytesCountSize bytesCount |
	bytesCountSize := (stream next: self byteCountArraySize) asInteger.
	bytesCount := (stream next: bytesCountSize) asInteger.
	self receiveBytes: (stream next: bytesCount)

]

{ #category : #initialization }
MpTcpTransporterOLD >> receptionServicePriority: anInteger [
	super receptionServicePriority: anInteger.
	receptionService communicationHandlingPriority: anInteger.
]

{ #category : #sending }
MpTcpTransporterOLD >> sendBytes: bytes toAddress: address [
	| socketStream bytesCountArray bytesCountSizeArray |
	socketStream := ZdcSocketStream openConnectionToHost: address ip port: address port.
	bytesCountArray := bytes size asByteArray.
	bytesCountSizeArray := bytesCountArray size asByteArrayOfSize: self byteCountArraySize.
	socketStream
		nextPutAll: bytesCountSizeArray;
		nextPutAll: bytesCountArray;
		nextPutAll: bytes;
		flush
]
