Trait {
	#name : #MpTMiddlewareDebugSupport,
	#category : #'MyPrecious-Tests'
}

{ #category : #communicating }
MpTMiddlewareDebugSupport >> defaultWaitForResultTimeoutDuration [
	^100 milliSeconds
]

{ #category : #initialization }
MpTMiddlewareDebugSupport >> proxyClass [
	^MpProxyForDebug
]
