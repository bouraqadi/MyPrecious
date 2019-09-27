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
	bytesCountSize := (stream next: self byteCountArraySize) asInteger.
	bytesCount := (stream next: bytesCountSize) asInteger.
	self receiveBytes: (stream next: bytesCount)

]

{ #category : #receiving }
MpTcpTransporter >> receiveObjectFromStream: stream [
	| bytesCountSize bytesCount bytes receivedObject |
	bytesCountSize := (stream next: self byteCountArraySize) asInteger.
	bytesCount := (stream next: bytesCountSize) asInteger.
	bytes := stream next: bytesCount.
	receivedObject := self materializeFrom: bytes.
	^self unmarshal: receivedObject.

]

{ #category : #sending }
MpTcpTransporter >> sendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	| targetAddress socketStream |
	targetAddress := targetRemoteReference address.
	socketStream := ZdcSocketStream
		openConnectionToHost: targetAddress ip
		port: targetAddress port.
	self setSocketStreamTimeout: socketStream.
	self sendObject: remoteMessage viaStream: socketStream.
	^socketStream

]

{ #category : #sending }
MpTcpTransporter >> sendObject: remoteMessage viaStream: socketStream [
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
MpTcpTransporter >> sendSynchronousMessage: remoteMessage to: targetReference [
	| socketStream |
	socketStream := self sendAsynchronousMessage: remoteMessage to: targetReference.
	^self receiveObjectFromStream: socketStream
]

{ #category : #initialization }
MpTcpTransporter >> serverClass [
	^NeTcpServer 
]

{ #category : #sending }
MpTcpTransporter >> setSocketStreamTimeout: socketStream [
	| timeoutSeconds |
	timeoutSeconds := self receptionTimeoutDuration asSeconds.
	timeoutSeconds = 0 ifTrue: [ timeoutSeconds := 1 ].
	socketStream timeout: timeoutSeconds
]
