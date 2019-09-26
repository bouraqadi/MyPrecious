Class {
	#name : #MpTcpTransporterOLD,
	#superclass : #MpTransporter,
	#category : #MyPreciousTcp
}

{ #category : #accessing }
MpTcpTransporterOLD >> byteCountArraySize [
	^4
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
