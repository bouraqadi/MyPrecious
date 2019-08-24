Class {
	#name : #MpMiddlewareForDebugTest,
	#superclass : #MpMiddlewareForTest,
	#category : #'MyPrecious-Tests'
}

{ #category : #initialization }
MpMiddlewareForDebugTest >> proxyClass [
	^MpDebugProxy
]
