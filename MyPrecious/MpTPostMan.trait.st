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
	] on: Error do: [ :exception | 
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

{ #category : #receiving }
MpTPostMan >> schedule: aValuable [
	| task |
	task := TKTTask valuable: aValuable.
	self incomingMessagesRunner schedule: task
]
