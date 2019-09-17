Class {
	#name : #MpChannelOLD,
	#superclass : #MpMiddlewarePart,
	#instVars : [
		'promisesDict',
		'promisesLock',
		'receptionService'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpChannelOLD class >> middleware: aMiddleware [
	^self new
		middleware: aMiddleware;
		yourself
]

{ #category : #initialization }
MpChannelOLD >> initialize [
	super initialize.
	promisesDict := WeakValueDictionary new.
	promisesLock := Mutex new.
	receptionService := CcService repeat: [ self receptionStep ]
]

{ #category : #communicating }
MpChannelOLD >> receptionStep [
	self receiveBytes: self incomingBytes
]
