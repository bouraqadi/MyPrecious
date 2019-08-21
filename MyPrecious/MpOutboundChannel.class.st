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

{ #category : #sending }
MpOutboundChannel >> newResultId [
	^UUID new
]

{ #category : #sending }
MpOutboundChannel >> receiveObject: remoteResponse [
	| promise |
	promise := promisesLock critical: [
		promisesDict at: remoteResponse id ifAbsent: [^self]].
	remoteResponse trigger: promise

]

{ #category : #sending }
MpOutboundChannel >> send: aMessage to: receiver [
	| promise resultId result semaphore |
	resultId := self newResultId.
	semaphore := Semaphore new.		
	promise := CcPromise
		onFulfillDo: [: answer | 
			result := answer.
			semaphore signal] 
		onRejectDo: [: exception | 
			result := [exception signal].
			semaphore signal].
	promisesLock critical: [
		promisesDict at: resultId put: promise].
	self send: aMessage to: receiver resultId: resultId.
	semaphore wait.
	^ result value
]

{ #category : #sending }
MpOutboundChannel >> send: aMessage to: receiver resultId: resultId [
	| remoteMessage |
	remoteMessage := MpRemoteMessage
		selector: aMessage selector
		arguments: aMessage arguments
		receiver: receiver 
		resultId: resultId.
	self sendObject: remoteMessage
]
