Trait {
	#name : #MpTMiddlewareDebugSupport,
	#category : #'MyPrecious-Tests'
}

{ #category : #initialization }
MpTMiddlewareDebugSupport >> proxyClass [
	^MpProxyForDebug
]

{ #category : #communicating }
MpTMiddlewareDebugSupport >> waitForResultTimeoutDuration [
	^100 milliSeconds
]
