Class {
	#name : #MpDebugProxy,
	#superclass : #MpProxy,
	#category : #'MyPrecious-Tests'
}

{ #category : #accessing }
MpDebugProxy >> class [
	^MpDebugProxy
]

{ #category : #accessing }
MpDebugProxy >> doesNotUnderstand: aMessage [
	| selector method |
	selector := aMessage selector.
	method := Object compiledMethodAt: selector ifAbsent: [ ^super doesNotUnderstand: aMessage ].
	^method valueWithReceiver: self arguments: aMessage arguments
]
