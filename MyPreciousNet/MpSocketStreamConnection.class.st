Class {
	#name : #MpSocketStreamConnection,
	#superclass : #MpConnection,
	#instVars : [
		'socketStream'
	],
	#category : #'MyPreciousNet-Common'
}

{ #category : #connecting }
MpSocketStreamConnection >> acceptConnectionWith: aSocketStream [
	self socketStream: aSocketStream
]

{ #category : #connecting }
MpSocketStreamConnection >> basicDisconnect [
	self socketStream ifNil: [ ^self ].
	self socketStream close
]

{ #category : #accessing }
MpSocketStreamConnection >> byteCountArraySize [
	^4
]

{ #category : #connecting }
MpSocketStreamConnection >> isSendingPossible [
	^self socketStream isConnected
]

{ #category : #receiving }
MpSocketStreamConnection >> receiveBytes [
	| bytesCountSize bytesCount |
	bytesCountSize := (socketStream next: self byteCountArraySize) asInteger.
	bytesCount := (socketStream next: bytesCountSize) asInteger.
	^socketStream next: bytesCount
	
]

{ #category : #connecting }
MpSocketStreamConnection >> receptionTimeoutSeconds [
	| timeoutSeconds |
	timeoutSeconds := self receptionTimeoutDuration asSeconds.
	timeoutSeconds = 0 ifTrue: [ ^1 ].
	^timeoutSeconds
]

{ #category : #sending }
MpSocketStreamConnection >> sendBytes: bytes [
	| bytesCountArray bytesCountSizeArray |
	bytesCountArray := bytes size asByteArray.
	bytesCountSizeArray := bytesCountArray size asByteArrayOfSize: self byteCountArraySize.
	self socketStream
		nextPutAll: bytesCountSizeArray;
		nextPutAll: bytesCountArray;
		nextPutAll: bytes;
		flush
]

{ #category : #accessing }
MpSocketStreamConnection >> socketStream [
	^ socketStream
]

{ #category : #accessing }
MpSocketStreamConnection >> socketStream: aSocketStream [
	socketStream := aSocketStream.
	socketStream timeout: self receptionTimeoutSeconds 
]
