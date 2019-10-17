Class {
	#name : #MpWebConnection,
	#superclass : #MpSocketStreamConnection,
	#category : #'MyPreciousNet-Web'
}

{ #category : #connecting }
MpWebConnection >> acceptConnectionWith: aSocketStream [
	| timing request |
	super acceptConnectionWith: aSocketStream.
	timing := ZnServerTransactionTiming new.
	request := ZnRequest readFrom: aSocketStream.

]

{ #category : #connecting }
MpWebConnection >> basicConnect [
	| newSocketStream |
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
