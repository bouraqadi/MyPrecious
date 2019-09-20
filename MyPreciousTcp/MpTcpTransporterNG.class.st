Class {
	#name : #MpTcpTransporterNG,
	#superclass : #MpTransporter,
	#category : #MyPreciousTcp
}

{ #category : #accessing }
MpTcpTransporterNG >> byteCountArraySize [
	^4
]

{ #category : #initialization }
MpTcpTransporterNG >> newReceptionService [
	^self serverClass new
		withCommunicationStreamDo: [ : stream | 
			self receiveMessageFromStream: stream ];
		yourself
]

{ #category : #accessing }
MpTcpTransporterNG >> port: integer [
	receptionService port: integer.

]

{ #category : #receiving }
MpTcpTransporterNG >> receiveMessageFromStream: stream [
	| receivedMessage |
	receivedMessage := self receiveObjectFromStream: stream.
	self sendObject: receivedMessage send viaStream: stream.
	
	
]

{ #category : #receiving }
MpTcpTransporterNG >> receiveObjectFromStream: stream [
	| bytesCountSize bytesCount bytes receivedObject |
	bytesCountSize := (stream next: self byteCountArraySize) asInteger.
	bytesCount := (stream next: bytesCountSize) asInteger.
	bytes := stream next: bytesCount.
	receivedObject := self materializeFrom: bytes.
	^self unmarshal: receivedObject.

]

{ #category : #initialization }
MpTcpTransporterNG >> receptionServicePriority: anInteger [
	super receptionServicePriority: anInteger.
	receptionService communicationHandlingPriority: anInteger.
]

{ #category : #sending }
MpTcpTransporterNG >> sendBytes: bytes toAddress: address [
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

{ #category : #sending }
MpTcpTransporterNG >> sendObject: remoteMessage viaStream: socketStream [
	| bytesCountArray bytes bytesCountSizeArray marshalledObject |
	marshalledObject := self marshal: remoteMessage.
	bytes := self serialize: marshalledObject.
	bytesCountArray := bytes size asByteArray.
	bytesCountSizeArray := bytesCountArray size
		asByteArrayOfSize: self byteCountArraySize.
	socketStream
		nextPutAll: bytesCountSizeArray;
		nextPutAll: bytesCountArray;
		nextPutAll: bytes;
		flush
]

{ #category : #sending }
MpTcpTransporterNG >> sendSynchronousMessage: remoteMessage to: targetReference [
	| targetAddress socketStream |
	targetAddress := targetReference address.
	socketStream := ZdcSocketStream
		openConnectionToHost: targetAddress ip
		port: targetAddress port.
	self sendObject: remoteMessage viaStream: socketStream.
	^self receiveObjectFromStream: socketStream
]

{ #category : #initialization }
MpTcpTransporterNG >> serverClass [
	^NeTcpServer 
]
