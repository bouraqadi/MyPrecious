Class {
	#name : #MpWebMiddlewareTest,
	#superclass : #MpTcpMiddlewareTest,
	#category : #MyPreciousNetTests
}

{ #category : #tests }
MpWebMiddlewareTest >> defaultProtocol [
	^MpWebFullAddress http
]

{ #category : #tests }
MpWebMiddlewareTest >> middlewareClass [
	^ MpWebMiddleware
]

{ #category : #tests }
MpWebMiddlewareTest >> newMiddleware [ 
	^super newMiddleware
		protocol: self defaultProtocol;
		yourself
]
