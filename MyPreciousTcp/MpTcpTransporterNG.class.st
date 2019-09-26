Class {
	#name : #MpTcpTransporterNG,
	#superclass : #MpTransporter,
	#category : #MyPreciousTcp
}

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
