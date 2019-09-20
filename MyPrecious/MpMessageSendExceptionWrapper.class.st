Class {
	#name : #MpMessageSendExceptionWrapper,
	#superclass : #MpMessageSendError,
	#instVars : [
		'originalException'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpMessageSendExceptionWrapper >> originalException [
	^ originalException
]

{ #category : #accessing }
MpMessageSendExceptionWrapper >> originalException: anObject [
	originalException := anObject
]
