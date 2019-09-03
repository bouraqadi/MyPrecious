Class {
	#name : #MpSpecificTcpMiddlewareTest,
	#superclass : #MpTcpMiddlewareTest,
	#traits : 'CcTWaitPolling',
	#classTraits : 'CcTWaitPolling classTrait',
	#category : #MyPreciousTcp
}

{ #category : #tests }
MpSpecificTcpMiddlewareTest >> middlewareClass [
	^ MpTcpMiddlewareForTest
]

{ #category : #tests }
MpSpecificTcpMiddlewareTest >> testChannelConnection [
	| valueHolder remoteReference outboundChannel |
	valueHolder := self newValueHolder.
	remoteReference := middlewareA export: valueHolder.
	self assert: middlewareA inboundChannels isEmpty.
	outboundChannel := middlewareB channelFactory outboundChannelTo: remoteReference.
	self waitUntil:  [middlewareA inboundChannels size = 1] timeout: 500 milliSeconds.

]

{ #category : #tests }
MpSpecificTcpMiddlewareTest >> testRemoteMessage [
	| proxy remoteReference doneSemaphore  result |
	doneSemaphore := Semaphore new.
	remoteReference := middlewareA export: [: x | x + 1].
	proxy := middlewareB proxyTo: remoteReference.
	[ 
		result := proxy value: 2.
		doneSemaphore signal.
	 ] fork.
	self assertSemaphore: doneSemaphore signaledWithinMilliseconds: 200.
	self assert: result equals: 3

]

{ #category : #tests }
MpSpecificTcpMiddlewareTest >> testStartStop [
	self allMiddleware do: [ : each |
		self assert: each isStarted.
		each stop.
		self assert: each isStopped.
		each start.
		self assert: each isStarted.
	]
]

{ #category : #tests }
MpSpecificTcpMiddlewareTest >> testTimeoutRemoteMessage [
	| proxy remoteReference infiniteWaitSemaphore doneSemaphore isTimeout |
	infiniteWaitSemaphore := Semaphore new.
	doneSemaphore := Semaphore new.
	remoteReference := middlewareA export: infiniteWaitSemaphore.
	proxy := middlewareB proxyTo: remoteReference.
	isTimeout := false.
	[ 
		[proxy wait] on: CcPromiseTimeout do: [: ex | isTimeout := true].
		doneSemaphore signal.
	 ] fork.
	self assertSemaphore: doneSemaphore signaledWithinMilliseconds: 200.
	self assert: isTimeout

]
