Class {
	#name : #MpWebServer,
	#superclass : #ZnSingleThreadedServer,
	#instVars : [
		'communicationHandlingBlock',
		'communicationHandlingPriority',
		'priority'
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
	^ZnResponse new
		statusLine: (ZnStatusLine ok);
		headers: ZnHeaders defaultResponseHeaders;
		yourself.
]

{ #category : #accessing }
MpWebServer >> priority [
	^ priority
]

{ #category : #accessing }
MpWebServer >> priority: anObject [
	priority := anObject
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
	"Start me. I will start listening on my port for incoming HTTP connections.
	If I am running, I will first stop and thus effectively restart"
	
	self stop: false.
	self class default = self ifTrue: [ self register ].
	process := [ [ self listenLoop ] repeat ]
		forkAt: self priority 
		named: self serverProcessName.
	self logStarted.

]

{ #category : #initialization }
MpWebServer >> withCommunicationStreamDo: aBlock [
	communicationHandlingBlock := aBlock
]
