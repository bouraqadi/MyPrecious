Trait {
	#name : #MpTPostMan,
	#category : #'MyPrecious-Kernel'
}

{ #category : #receiving }
MpTPostMan >> basicDeliverSynchronousMessage: remoteMessage [
	^[ 
		self normalResponseClass
			id: remoteMessage responseId
			result: remoteMessage send 
	] on: Exception do: [ :exception | 
		self exceptionResponseClass
				id: remoteMessage responseId
				exception: exception 
	].
	
]

{ #category : #receiving }
MpTPostMan >> deliverAsynchronousMessage: remoteMessage [
	remoteMessage send 

]

{ #category : #receiving }
MpTPostMan >> deliverSynchronousMessage: remoteMessage [
	self explicitRequirement
]

{ #category : #receiving }
MpTPostMan >> exceptionResponseClass [
	^ MpExceptionRemoteResponse
]

{ #category : #receiving }
MpTPostMan >> normalResponseClass [
	^ MpNormalRemoteResponse
]
