Class {
	#name : #MpInboundChannel,
	#superclass : #MpChannel,
	#category : #'MyPrecious-Kernel'
}

{ #category : #communicating }
MpInboundChannel >> exceptionResponseClass [
	^ MpExceptionRemoteResponse
]

{ #category : #communicating }
MpInboundChannel >> normalResponseClass [
	^ MpNormalRemoteResponse
]

{ #category : #communicating }
MpInboundChannel >> receiveMessage: remoteMessage [
	| result response |
	[ 
		result := remoteMessage send.
		response := self normalResponseClass
			id: remoteMessage resultId
			result: result 
	] on: Exception do: [ :exception | 
		response := self exceptionResponseClass
				id: remoteMessage resultId
				exception: exception 
	].
	self sendObject: response
]
