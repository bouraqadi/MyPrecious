Class {
	#name : #MpWebServer,
	#superclass : #ZnSingleThreadedServer,
	#instVars : [
		'communicationHandlingBlock',
		'communicationHandlingPriority',
		'service'
	],
	#category : #'MyPreciousNet-Web'
}

{ #category : #'request handling' }
MpWebServer >> augmentResponse: response forRequest: request [
	super augmentResponse: response forRequest: request.
	response setKeepAliveFor: request.
	response setConnectionCloseFor: request
]

{ #category : #'request handling' }
MpWebServer >> authenticateAndDelegateRequest: request [
	^ self
		authenticateRequest: request
		do: [ self handleRequest: request ]
]

{ #category : #accessing }
MpWebServer >> communicationHandlingPriority [
	^ communicationHandlingPriority
]

{ #category : #initialization }
MpWebServer >> communicationHandlingPriority: anObject [
	communicationHandlingPriority := anObject
]

{ #category : #initialization }
MpWebServer >> defaultPriority [
	^Processor userBackgroundPriority
]

{ #category : #'request handling' }
MpWebServer >> executeOneRequestResponseOn: stream [
	| request response timing|
	timing := ZnServerTransactionTiming new.
	(request := self readRequest: stream timing: timing)
		ifNil: [ ^ true ]
		ifNotNil: [ 
			response := self handleRequest: request timing: timing.
			self augmentResponse: response forRequest: request.
			self writeResponse: response on: stream timing: timing.
		].

]

{ #category : #'request handling' }
MpWebServer >> handleRequest: request [
	^ZnResponse ok: (ZnEntity text: 'Connection established').
]

{ #category : #initialization }
MpWebServer >> initialize [
	super initialize.
	service := CcService repeat: [ self listenLoop ] ensure: [self releaseServerSocket].
	self communicationHandlingPriority: self defaultPriority.
]

{ #category : #testing }
MpWebServer >> isRunning [
	^self isStarted
]

{ #category : #testing }
MpWebServer >> isStarted [
	^service isStarted
]

{ #category : #accessing }
MpWebServer >> priority [
	^service priority
]

{ #category : #accessing }
MpWebServer >> priority: anObject [
	service priority: anObject
]

{ #category : #'request handling' }
MpWebServer >> serveConnectionOn: listeningSocket [
	| communicationStream communicationSocket |
	communicationSocket := listeningSocket waitForAcceptFor: self acceptWaitTimeout.
	communicationSocket ifNil: [ ^ self noteAcceptWaitTimedOut ].
	communicationStream := self socketStreamOn: communicationSocket.
	self executeOneRequestResponseOn: communicationStream.
	[communicationHandlingBlock cull: communicationStream] forkAt: self communicationHandlingPriority.

]

{ #category : #public }
MpWebServer >> start [
	service 
		name: self serverProcessName;
		start

]

{ #category : #public }
MpWebServer >> stop [
	service stop
]

{ #category : #initialization }
MpWebServer >> withCommunicationStreamDo: aBlock [
	communicationHandlingBlock := aBlock
]
