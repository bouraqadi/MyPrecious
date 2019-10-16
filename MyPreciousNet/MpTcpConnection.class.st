Class {
	#name : #MpTcpConnection,
	#superclass : #MpSocketStreamConnection,
	#category : #'MyPreciousNet-Tcp'
}

{ #category : #connecting }
MpTcpConnection >> basicConnect [
	| newSocketStream |
	self otherSideAddress ifNil: [ MpConnectionFailed signal ].
	newSocketStream := ZdcSocketStream
		openConnectionToHost: self otherSideAddress ip
		port: self otherSideAddress port.
	self socketStream: newSocketStream
]
