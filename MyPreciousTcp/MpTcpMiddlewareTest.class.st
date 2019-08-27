Class {
	#name : #MpTcpMiddlewareTest,
	#superclass : #MpMiddlwareTest,
	#traits : 'CcTWaitPolling',
	#classTraits : 'CcTWaitPolling classTrait',
	#category : #MyPreciousTcp
}

{ #category : #tests }
MpTcpMiddlewareTest >> middlewareClass [
	^ MpTcpMiddleware
]

{ #category : #tests }
MpTcpMiddlewareTest >> setUp [
	super setUp.
	self allMiddleware do: [ : each |
		each 
			port: NeTcpUsedPortsTracker freePortAtRandom;
			start ]
]

{ #category : #tests }
MpTcpMiddlewareTest >> tearDown [
	super tearDown.
	self allMiddleware do: [ : each | each stop]
]

{ #category : #tests }
MpTcpMiddlewareTest >> testChannelConnection [
	| valueHolder remoteReference outboundChannel |
	valueHolder := self newValueHolder.
	remoteReference := middlewareA export: valueHolder.
	self assert: middlewareB inboundChannels isEmpty.
	outboundChannel := middlewareA channelFactory channelTo: remoteReference.
	self assert: middlewareB inboundChannels size equals: 1.

]

{ #category : #tests }
MpTcpMiddlewareTest >> testStartStop [
	self allMiddleware do: [ : each |
		self assert: each isStarted.
		each stop.
		self waitUntil: each isStopped.
		each start.
		self waitUntil: each isStarted.
	]
]
