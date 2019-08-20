Class {
	#name : #MpProxy,
	#superclass : #Object,
	#instVars : [
		'channel',
		'remoteReference'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpProxy class >> channel: aChannel remoteReference: aRemoteReference [
	^ self new
		channel: aChannel remoteReference: aRemoteReference;
		yourself
]

{ #category : #'initialize-release' }
MpProxy >> channel: aChannel remoteReference: aRemoteReference [
	remoteReference := aRemoteReference. 
	channel := aChannel.
]

{ #category : #'reflective operations' }
MpProxy >> doesNotUnderstand: aMessage [
	^channel send: aMessage to: self
]

{ #category : #marshalling }
MpProxy >> marshalWith: marshaller [
	^marshaller marshalRemoteReference: remoteReference
]
