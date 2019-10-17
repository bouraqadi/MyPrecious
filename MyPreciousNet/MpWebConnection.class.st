Class {
	#name : #MpWebConnection,
	#superclass : #MpSocketStreamConnection,
	#category : #'MyPreciousNet-Web'
}

{ #category : #connecting }
MpWebConnection >> basicConnect [
	| newSocketStream |
	self otherSideAddress ifNil: [MpConnectionFailed signal].
	newSocketStream := ZnClient new 
		ifFail: [ :exception | MpConnectionFailed signal];
		get: self otherSideUrl;
		connection.
	self socketStream: newSocketStream

]

{ #category : #connecting }
MpWebConnection >> otherSideUrl [
	^self otherSideAddress url
]
