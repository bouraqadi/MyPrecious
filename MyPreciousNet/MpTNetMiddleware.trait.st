Trait {
	#name : 'MpTNetMiddleware',
	#category : 'MyPreciousNet-Common',
	#package : 'MyPreciousNet',
	#tag : 'Common'
}

{ #category : 'initialization' }
MpTNetMiddleware >> initAddress: anAddress [

	anAddress ip: self localHostIp
]

{ #category : 'initialization' }
MpTNetMiddleware >> localHostIp [
	^NetNameResolver localHostAddress
]

{ #category : 'initialization' }
MpTNetMiddleware >> port: portNumber [
	self transporter port: portNumber.
	self address port: portNumber.
]
