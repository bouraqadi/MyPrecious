Class {
	#name : #MpProxyForDebug,
	#superclass : #Object,
	#instVars : [
		'channel',
		'remoteReference'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #'instance creation' }
MpProxyForDebug class >> channel: aChannel remoteReference: aRemoteReference [
	^ self basicNew
		channel: aChannel remoteReference: aRemoteReference;
		yourself
]

{ #category : #'initialize-release' }
MpProxyForDebug >> channel: aChannel remoteReference: aRemoteReference [
	remoteReference := aRemoteReference. 
	channel := aChannel.
]

{ #category : #'reflective operations' }
MpProxyForDebug >> doesNotUnderstand: aMessage [
	^ channel sendMessageSynchronously: aMessage to: self
]

{ #category : #marshalling }
MpProxyForDebug >> marshalWith: marshaller [
	^marshaller marshalRemoteReference: remoteReference
]

{ #category : #accessing }
MpProxyForDebug >> yourself [
	^self
]
