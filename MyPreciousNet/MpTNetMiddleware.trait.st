Trait {
	#name : #MpTNetMiddleware,
	#category : #'MyPreciousNet-Common'
}

{ #category : #initialization }
MpTNetMiddleware >> localHostIp [
	^NetNameResolver localHostAddress
]

{ #category : #initialization }
MpTNetMiddleware >> newAddress [
	^super newAddress
		ip: self localHostIp;
		yourself
]

{ #category : #initialization }
MpTNetMiddleware >> port: portNumber [
	self transporter port: portNumber.
	self address port: portNumber.
]
