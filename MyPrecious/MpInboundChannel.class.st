Class {
	#name : #MpInboundChannel,
	#superclass : #MpChannel,
	#category : #'MyPrecious-Kernel'
}

{ #category : #receiving }
MpInboundChannel >> exceptionResponseClass [
	^ MpExceptionResponse
]

{ #category : #receiving }
MpInboundChannel >> normalResponseClass [
	^ MpNormalResponse
]

{ #category : #receiving }
MpInboundChannel >> receiveObject: remoteMessage [
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
