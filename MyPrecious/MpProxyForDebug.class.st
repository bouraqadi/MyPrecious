Class {
	#name : #MpProxyForDebug,
	#superclass : #MpProxy,
	#category : #'MyPrecious-Tests'
}

{ #category : #'instance creation' }
MpProxyForDebug class >> channel: aChannel remoteReference: aRemoteReference [
	^ self basicNew
		channel: aChannel remoteReference: aRemoteReference;
		yourself
]

{ #category : #accessing }
MpProxyForDebug >> channel [
	^ channel
]

{ #category : #accessing }
MpProxyForDebug >> channel: anObject [
	channel := anObject
]

{ #category : #'reflective operations' }
MpProxyForDebug >> doesNotUnderstand: aMessage [
	| method |
	(#(class value) includes: aMessage selector) ifTrue: [^self remoteSend: aMessage].
	method := [Object compiledMethodAt: aMessage selector] 
		on: KeyNotFound 
		do: [: ex| ^self remoteSend: aMessage].
	^method valueWithReceiver: self arguments: aMessage arguments 
]

{ #category : #accessing }
MpProxyForDebug >> remoteReference [
	^ remoteReference
]

{ #category : #accessing }
MpProxyForDebug >> remoteReference: anObject [
	remoteReference := anObject
]

{ #category : #'reflective operations' }
MpProxyForDebug >> remoteSend: aMessage [
	^super doesNotUnderstand: aMessage
]
