Class {
	#name : #MpTcpConnection,
	#superclass : #MpConnection,
	#instVars : [
		'socketStream'
	],
	#category : #MyPreciousTcp
}

{ #category : #accessing }
MpTcpConnection >> byteCountArraySize [
	^4
]

{ #category : #connecting }
MpTcpConnection >> connectTo: targetRemoteReference [
	| targetAddress newSocketStream |
	targetAddress := targetRemoteReference address.
	newSocketStream := ZdcSocketStream
		openConnectionToHost: targetAddress ip
		port: targetAddress port.
	self socketStream: newSocketStream
]

{ #category : #'instance creation' }
MpTcpConnection >> newReceptionServiceDoing: aBlock [
	^CcService repeat: aBlock
]

{ #category : #receiving }
MpTcpConnection >> receiveBytes [
	| bytesCountSize bytesCount |
	bytesCountSize := (socketStream next: self byteCountArraySize) asInteger.
	bytesCount := (socketStream next: bytesCountSize) asInteger.
	^socketStream next: bytesCount
	
]

{ #category : #connecting }
MpTcpConnection >> receptionTimeoutSeconds [
	| timeoutSeconds |
	timeoutSeconds := self receptionTimeoutDuration asSeconds.
	timeoutSeconds = 0 ifTrue: [ ^1 ].
	^timeoutSeconds
]

{ #category : #sending }
MpTcpConnection >> sendBytes: bytes [
	| bytesCountArray bytesCountSizeArray |
	bytesCountArray := bytes size asByteArray.
	bytesCountSizeArray := bytesCountArray size asByteArrayOfSize: self byteCountArraySize.
	socketStream
		nextPutAll: bytesCountSizeArray;
		nextPutAll: bytesCountArray;
		nextPutAll: bytes;
		flush
]

{ #category : #accessing }
MpTcpConnection >> socketStream [
	^ socketStream
]

{ #category : #accessing }
MpTcpConnection >> socketStream: aSocketStream [
	socketStream := aSocketStream.
	socketStream timeout: self receptionTimeoutSeconds 
]
