Class {
	#name : #MpOutboundChannel,
	#superclass : #MpChannel,
	#instVars : [
		'promisesDict',
		'promisesLock'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #initialization }
MpOutboundChannel >> initialize [
	super initialize.
	promisesDict := WeakValueDictionary new.
	promisesLock := Mutex new.
]

{ #category : #communicating }
MpOutboundChannel >> newResultId [
	^UUID new
]

{ #category : #communicating }
MpOutboundChannel >> receiveResponse: remoteResponse [
	| promise |
	promise := promisesLock critical: [
		promisesDict at: remoteResponse id ifAbsent: [^self]].
	remoteResponse trigger: promise

]

{ #category : #communicating }
MpOutboundChannel >> send: aMessage to: receiver [
	| promise resultId resultBlock semaphore |
	resultId := self newResultId.
	semaphore := Semaphore new.		
	promise := CcPromise
		onFulfillDo: [: answer | 
			resultBlock := [answer].
			semaphore signal] 
		onRejectDo: [: exception | 
			resultBlock := [exception signal].
			semaphore signal].
	promisesLock critical: [
		promisesDict at: resultId put: promise].
	self send: aMessage to: receiver resultId: resultId.
	semaphore wait.
	^ resultBlock value
]

{ #category : #communicating }
MpOutboundChannel >> send: aMessage to: receiver resultId: resultId [
	| remoteMessage |
	remoteMessage := MpRemoteMessage
		selector: aMessage selector
		arguments: aMessage arguments
		receiver: receiver 
		resultId: resultId.
	self sendObject: remoteMessage
]
