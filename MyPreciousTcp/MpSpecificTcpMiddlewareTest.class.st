Class {
	#name : #MpSpecificTcpMiddlewareTest,
	#superclass : #MpTcpMiddlewareTest,
	#category : #MyPreciousTcp
}

{ #category : #tests }
MpSpecificTcpMiddlewareTest >> middlewareClass [
	^ MpTcpMiddlewareForTest
]

{ #category : #tests }
MpSpecificTcpMiddlewareTest >> testChannelConnection [
	| valueHolderA remoteReferenceA outboundChannelB inboundChannelA |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	self assert: middlewareA inboundChannels isEmpty.
	outboundChannelB := middlewareB channelFactory newOutboundChannelTo: remoteReferenceA.
	self assert: outboundChannelB socketStream isConnected.
	self waitUntil:  [middlewareA inboundChannels size = 1] timeout: 500 milliSeconds.
	inboundChannelA := middlewareA inboundChannels anyOne.
	self assert: inboundChannelA socketStream isConnected.

]

{ #category : #tests }
MpSpecificTcpMiddlewareTest >> testChannelSendMessageNoWait [
	| doneSemaphore remoteReferenceA proxyB channelB message |
	doneSemaphore := Semaphore new.
	remoteReferenceA := middlewareA export: [: x | x + 1].
	proxyB := middlewareB proxyTo: remoteReferenceA.
	channelB := proxyB channel.
	message := Message selector: #value: arguments: #(2).
	channelB sendMessageNoWait: message to: proxyB responseId: #someId.

]

{ #category : #tests }
MpSpecificTcpMiddlewareTest >> testInboundChannelReceiveObject [
	| remoteReferenceA inboundChannelA message proxyB outboundChannelB responseId promiseA |
	remoteReferenceA := middlewareA export: [: x | x + 1].
	proxyB := middlewareB proxyTo: remoteReferenceA.
	outboundChannelB := proxyB channel.
	responseId := #someId.
	promiseA := CcPromise new.
	outboundChannelB promisesDict at: responseId put: promiseA.
	self waitWhile:  [middlewareA inboundChannels isEmpty] timeout: 500 milliSeconds.
	inboundChannelA := middlewareA inboundChannels anyOne.
	message := MpRemoteMessage
		selector: #value:
		arguments: #(2)
		receiver: remoteReferenceA 
		responseId: responseId.
	inboundChannelA receiveObject: message.
	self assert: promiseA isSettled
	
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
MpSpecificTcpMiddlewareTest >> testSendMessageNoWait [
	| remoteReferenceA proxyB channelB message |
	remoteReferenceA := middlewareA export: [: x | x + 1].
	proxyB := middlewareB proxyTo: remoteReferenceA.
	channelB := proxyB channel.
	message := Message selector: #value: arguments: #(2).
	channelB sendMessageNoWait: message to: proxyB responseId: #someId.

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
