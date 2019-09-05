Class {
	#name : #MpBasicMiddlewareTest,
	#superclass : #MpMiddlewareTest,
	#category : #'MyPrecious-Tests'
}

{ #category : #tests }
MpBasicMiddlewareTest >> inboundChannelAt: aMiddleware linkedTo: otherSideOutboundChannel [
	^(aMiddleware inboundChannelWith: nil)
			receiveQueue: otherSideOutboundChannel sendQueue;
			receiveQueue: otherSideOutboundChannel receiveQueue;
			yourself
	
]

{ #category : #tests }
MpBasicMiddlewareTest >> middlewareClass [
	^ MpMiddlewareForTest
]
