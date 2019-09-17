Class {
	#name : #MpMiddlewareTestOLD,
	#superclass : #TestCase,
	#traits : 'CcTConcurrencyTest + CcTWaitPolling',
	#classTraits : 'CcTConcurrencyTest classTrait + CcTWaitPolling classTrait',
	#instVars : [
		'middlewareA',
		'middlewareB',
		'middlewareC',
		'initialServices'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #tests }
MpMiddlewareTestOLD >> runCaseManaged [
	"We don't want SUnit terminate our processes, because it makes debugging difficult. 
	We want to see currently active processes/services while debugging failures.
	Our setup/tearDown deal with clean up."
	self runCase

]

{ #category : #tests }
MpMiddlewareTestOLD >> setUp [
	super setUp.
	initialServices := CcService allInstances.
	middlewareA := 	self middlewareClass new.
	middlewareB := 	self middlewareClass new.
	middlewareC := 	self middlewareClass new.

]

{ #category : #tests }
MpMiddlewareTestOLD >> tearDown [
	| newServices |
	super tearDown.
	newServices := CcService allInstances copyWithoutAll: initialServices.
	newServices do: #stop
]

{ #category : #tests }
MpMiddlewareTestOLD >> testChannelsCreation [
	| valueHolderA remoteReferenceA proxyB |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	self assert: middlewareA inboundChannels isEmpty.
	self assert: middlewareB outboundChannelsDict isEmpty.
	proxyB := middlewareB proxyTo: remoteReferenceA.
	self waitUntil: [middlewareA inboundChannels size = 1].
	self waitUntil: [middlewareB outboundChannelsDict size = 1].
	self assert: (middlewareA inboundChannels anyOne) isStarted.
	self assert: (middlewareB outboundChannelsDict at: remoteReferenceA) isStarted.
]

{ #category : #tests }
MpMiddlewareTestOLD >> testException [
	| remoteReference proxy |
	remoteReference := middlewareA export: Object new.
	proxy := middlewareB proxyTo: remoteReference.
	self should: [proxy foo] raise: MpRemoteException
]

{ #category : #tests }
MpMiddlewareTestOLD >> testInboundChannelReceiveObject [
	| remoteReferenceA inboundChannelA message total |
	total := 0.
	remoteReferenceA := middlewareA export: [: x | total := x + total].
	middlewareB outboundChannelTo: remoteReferenceA.
	self waitUntil: [middlewareA inboundChannels size = 1] timeout: 100 milliSeconds.
	inboundChannelA := middlewareA inboundChannels anyOne. 
	message := MpRemoteMessage
		selector: #value:
		arguments: #(2)
		receiver: remoteReferenceA 
		responseId: #any.
	inboundChannelA receiveObject: message.
	self assert: total equals: 2.
]

{ #category : #tests }
MpMiddlewareTestOLD >> testMessagesInDifferentProcessesGetValidResponses [
	| valueHolderA1 valueHolderA2 remoteReferenceA1 remoteReferenceA2 proxyB1 proxyB2 semaphore1 semaphore2 result1 result2 process1 process2 |
	valueHolderA1 := self newValueHolder.
	valueHolderA1 contents: 1.
	remoteReferenceA1 := middlewareA export: valueHolderA1.
	valueHolderA2 := self newValueHolder.
	valueHolderA2 contents: 2.
	remoteReferenceA2 := middlewareA export: valueHolderA2.
	proxyB1 := middlewareB proxyTo: remoteReferenceA1.
	semaphore1 := Semaphore new.
	proxyB2 := middlewareB proxyTo: remoteReferenceA2.
	semaphore2 := Semaphore new.
	process1 := CcService do: [ 
		result1 := proxyB1 contents.
		semaphore1 signal.
	 ].
	process2 := CcService do: [ 
		result2 := proxyB2 contents.
		semaphore2 signal.
	 ].
	{process1. process2} do: [ : each |
		each
			priority: 20;
			start

	].
	self assertSemaphore: semaphore1 signaledWithinMilliseconds: 500.
	self assertSemaphore: semaphore2 signaledWithinMilliseconds: 500.
	self assert: result1 equals: 1.
	self assert: result2 equals: 2.
	
]

{ #category : #tests }
MpMiddlewareTestOLD >> testOutboundChannelSendMessageNoWait [
	| remoteReferenceA message outboundChannelB proxyB total|
	total := 0.
	remoteReferenceA := middlewareA export: [: x | total := x + total].
	proxyB := middlewareB proxyTo: remoteReferenceA.
	message := Message
		selector: #value:
		arguments: #(2).
	outboundChannelB := middlewareB outboundChannelTo: remoteReferenceA.
	outboundChannelB sendMessageNoWait: message to: proxyB responseId: #any.
	self waitUntil: [total = 2] onTimeout: 300 milliSeconds do: [ self fail: 'Assertion failed' ]
	
]
